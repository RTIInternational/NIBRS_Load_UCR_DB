# mypy: ignore-errors
import argparse
from contextlib import contextmanager
import importlib.util
import logging
from pathlib import Path

import time
import dotenv
import yaml
from DatabaseManager import DatabaseManager

class CustomFormatter(logging.Formatter):
    def format(self, record):
        record.asctime = self.formatTime(record, self.datefmt)
        return super().format(record)

formatter = CustomFormatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

handler = logging.StreamHandler()
handler.setFormatter(formatter)

logging.basicConfig(level=logging.INFO, handlers=[handler])

def log_duration(time_A, time_B, filename):
    elapsed_time = round(time_B - time_A, 2)
    if elapsed_time > 3600:
        elapsed_time = round(elapsed_time / 3600, 2)
        logging.info(f"Executed {filename} in {elapsed_time} hours")
    elif elapsed_time > 60:
        elapsed_time = round(elapsed_time / 60, 2)
        logging.info(f"Executed {filename} in {elapsed_time} minutes")
    else:
        logging.info(f"Executed {filename} in {elapsed_time} seconds")

@contextmanager
def record_duration(filename):
  time_A = time.time()
  try:
    yield
  finally:
    time_B = time.time()
    log_duration(time_A, time_B, filename)

def get_file_path(file_name, base_path):
    # If not, create a new path from current_file_path and env_path
    file_path = Path(base_path) / file_name
    logging.info(f"Checking if {file_path} is a file or directory")
    if Path(file_path).is_file() or Path(file_path).is_dir():
        return file_path
    else:
        if Path(file_name).is_file() or Path(file_name).is_dir():
            return Path(file_name)
        else:
            logging.warning(f"File {file_name} not found at {file_path}")
            return None


def initialize(env_path=".env", verbose=False):
    if verbose:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)

    current_file_path = Path(__file__).resolve().parent
    # Check if env_path is a file
    logging.debug(f"Current file path: {current_file_path} + env_path: {env_path}")
    env_path = get_file_path(env_path, current_file_path)

    logging.info(f"Loading environment variables from {env_path}")
    # load the .env file for the psql command
    dotenv.load_dotenv(env_path)

    # Load the .env file using values to access via config variable
    config = dotenv.dotenv_values(env_path)

    data_dir = config.get("DATADIR", "data")

    # Set BASEPATH to run from anywhere, but since this will often be run inline
    # use the currenty directory as a shortcut
    base_path = get_file_path(config.get("BASEPATH"), current_file_path)

    # This script uses two database connections both on the same database server
    # 1) existing_db_name: a database we can connect to before importing CJIS
    #   db, typically the default database with an admin user
    # 2) new_db_name: the name of the database we want to create and import the
    #   CJIS ucr database into
    #   * note the CJIS database files we recieve set this database name
    #       (typically to "ucr_prd") so check to ensure the name in their files
    #       does not exist on your target database server and set the new_db_name
    #       to that exact value (alternatively you could change the name in the .sql
    #       files before running this script, but that is not recommended,as it might
    #       lead to unexpected errors in the import process)

    db_host = config.get("PGHOST")
    db_port = config.get("PGPORT")
    db_user = config.get("PGUSER")
    db_password = config.get("PGPASSWORD")
    existing_db_name = config.get("EXISTING_PGDATABASE")
    new_db_name = config.get("IMPORT_PGDATABASE")

    logging.debug(
        f"existing_db_name: {existing_db_name}, new_db_name: {new_db_name}, base_path: {base_path}, \
                  data_dir: {data_dir}, db_host: {db_host}, db_port: {db_port}, db_user: {db_user}, db_password: {db_password}"
    )

    existing_db = DatabaseManager(
        db_host, db_port, existing_db_name, db_user, db_password
    )
    new_db = DatabaseManager(db_host, db_port, new_db_name, db_user, db_password)

    return (
        existing_db,
        existing_db_name,
        new_db,
        new_db_name,
        base_path,
        data_dir,
        config,
    )


def load_sql_files_from_config(config_section, base_path, db_manager, env_config):
    """
    Load SQL files specified in a config section

    Args:
        config_section (list): List of SQL file configurations from yaml config
        base_path (Path): Base path for finding SQL files
        db_manager (DatabaseManager): Database manager instance to run SQL
        env_config (dict): Environment configuration values
    """
    for sql_file_details in config_section:
        file_name = sql_file_details.get("file_name")
        sql_file = Path(base_path, file_name)

        if not sql_file:
            logging.error(f"File {sql_file} not found")
            continue

        if file_name.endswith(".py"):
            # Handle Python files that generate SQL
            parameter_name = sql_file_details.get("parameter_name")
            parameter_value = env_config.get(parameter_name)

            logging.info(
                f"Loading {sql_file} where {parameter_name} is {parameter_value}"
            )

            try:
                # Import and execute Python module
                spec = importlib.util.spec_from_file_location("module.name", sql_file)
                module = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(module)
                sql_string = module.get_sql_string(parameter_value)
                db_manager.run_sql(sql_string)

            except Exception as e:
                logging.error(f"Error importing {sql_file}: {str(e)}")
                raise e
        else:
            # Handle regular SQL files
            db_manager.load_psql_file(sql_file)


if __name__ == "__main__":
    # Parse command-line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", help="Path to .env file")
    parser.add_argument("--file_name", nargs="?", help="Specific file to run")
    parser.add_argument(
        "--skip_setup", action="store_true", help="Skip the extra setup file"
    )
    parser.add_argument(
        "--skip_pre", action="store_true", help="Skip the data-pre file"
    )
    parser.add_argument("--skip_data", action="store_true", help="Skip the data file")
    parser.add_argument(
        "--skip_post", action="store_true", help="Skip the data-post file"
    )
    parser.add_argument(
        "--skip_public",
        action="store_true",
        help="Skip the public schema creation steps",
    )
    parser.add_argument(
        "--skip_user_access",
        action="store_true",
        help="Skip setting the user access creation steps",
    )

    parser.add_argument(
        "--drop_db",
        action="store_true",
        help="Drop the new database after a failed import, so you can start over",
    )

    parser.add_argument("--verbose", action="store_true", help="Enable verbose logging")

    args = parser.parse_args()

    # Load the .env file
    (
        existing_db,
        existing_db_name,
        new_db,
        new_db_name,
        base_path,
        data_dir,
        env_config,
    ) = initialize(
        args.config if args.config else ".env", args.verbose if args.verbose else False
    )

    base_path = Path(base_path)
    data_path = get_file_path(data_dir, base_path)

    if args.drop_db:
        logging.info(f"Dropping database {new_db_name}")
        existing_db.drop_database(new_db_name)

    # Run a specific file if provided as a command-line argument
    if args.file_name:
        file_path = base_path / args.file_name
        existing_db.load_psql_file(file_path)
    else:
        # Read the SQL file list from the configuration file
        print("CWD:", base_path)
        with open(f"{base_path}/config.yaml", "r") as f:
            config = yaml.safe_load(f)

        new_db_pre_file = get_file_path(
            config["Database"]["CJIS_Pre"]["file_name"], base_path
        )
        new_db_data_file = get_file_path(
            config["Database"]["CJIS_Data"]["file_name"], base_path
        )
        new_db_post_file = get_file_path(
            config["Database"]["CJIS_Post"]["file_name"], base_path
        )

        # Run Extra Setup file (if it exists)
        # this extra setup should only be run once to avoid errors in the import porcess
        # If the future steps error, restart process with --skip_setup
        if args.skip_setup:
            logging.info("Skipping pre file, per command line argument")
        else:
            logging.debug(f"skip_setup set to: {args.skip_setup}")
            load_sql_files_from_config(
                config["Database"]["User_Setup"], base_path, existing_db, env_config
            )

        # Run Pre (setup) SQL file
        if existing_db.db_exists(new_db_name):
            # Only check if the db exists the "pre" file
            logging.info(
                "New DB name already exists. Skipping db creation; If this is unexpected consider deleting and starting over"
            )
        else:
            logging.info(f"Importing database {new_db_name}")

            # "pre" should only be run once to avoid errors in the import porcess
            # If this errors out delete the database and restart
            if args.skip_pre:
                logging.info("Skipping pre file, per command line argument")
            elif new_db_pre_file:
                logging.debug(f"skip_pre: {args.skip_pre}")
                try:
                    logging.info(f"Running {new_db_pre_file}")
                    existing_db.load_psql_file(new_db_pre_file)
                except Exception as e:
                    logging.error(
                        f"An error occurred during the database import of {new_db_pre_file}: {str(e)}"
                    )
                    logging.error(
                        f"Please delete the newly created database {new_db_name}and restart the process"
                    )
                    raise e
            else:
                logging.error(f"CJIS schema file: {new_db_pre_file} not found")
                raise FileNotFoundError(
                    f"CJIS schema file: {new_db_pre_file} not found"
                )

            if args.skip_data:
                logging.info("Skipping data file, per command-line argument")
            elif existing_db.db_exists(new_db_name):
                if new_db_data_file:
                    # Verify the database was created before continuing
                    # I couldn't think of a good way to check if the data import was already run
                    # (unless there is a way to continue a pg-restore?)
                    # So if this process fails it's best to start over manually
                    try:
                        logging.info(f"Running {new_db_data_file}")
                        with record_duration(new_db_data_file):
                            new_db.restore_pg_dump(new_db_data_file)

                    except Exception as e:
                        logging.error(
                            f"An error occurred during the database import of {new_db_data_file}: {str(e)}"
                        )
                        logging.error(
                            f"Please delete the newly created database {new_db_name} and restart the process"
                        )
                        raise e
                else:
                    logging.error("Data file not found")
                    raise FileNotFoundError("Data file not found")
            else:
                logging.error(
                    f"Database {new_db_name} not found/ not accessible from {existing_db_name}"
                )
                raise FileNotFoundError("Database not found")

        # "Post" can be run multiple times without issue, and if it fails then it needs to be re-run
        if args.skip_post:
            logging.info("Skipping post file, per command-line argument")
        elif new_db_post_file:
            try:
                logging.info(f"Running {new_db_post_file}")
                new_db.load_psql_file(new_db_post_file)
            except Exception as e:
                logging.error(
                    f"An error occurred during the database import of {new_db_post_file}: {str(e)}"
                )
                logging.error(
                    f"This is may be because the post file, {new_db_post_file} contains a create database statement, check the file and delete that line if it exists and try again. There is no problem running this file multiple times. Continuing by default, but you may want to restart the entire process by deleting the database {new_db_name} and restarting the import."
                )
                # raise e
        else:
            logging.error("Post file not found")
            raise FileNotFoundError("Post file not found")

        if args.skip_public:
            logging.info("Skipping public schema files, per command-line argument")
        else:
            load_sql_files_from_config(
                config["Database"]["PUBLIC_SQL"], base_path, new_db, env_config
            )

        if args.skip_user_access:
            logging.info("Skipping public schema files, per command-line argument")
        else:
            load_sql_files_from_config(
                config["Database"]["User_Access"], base_path, new_db, env_config
            )
