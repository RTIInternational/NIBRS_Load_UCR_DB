import psycopg2
from psycopg2 import sql
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import subprocess
import logging
import time


class DatabaseManager:
    def __init__(self, host, port, dbname, user, password):
        if not password or password == "":
            logging.error("PGPASSWORD environment variable not set")
            raise Exception("Please set PGPASSWORD environment variable")
        elif not all([host, port, dbname, user]):
            logging.error(
                "All parameters (host, port, database_name. user) must be provided."
            )
            raise Exception(
                f"Please check all environment variables: {host}, {port}, {dbname}, {user}"
            )
        else:
            self.params = {
                "host": host,
                "port": port,
                "dbname": dbname,
                "user": user,
                "password": password,
                "keepalives": 1,
                "keepalives_idle": 1200,
                "keepalives_interval": 5,
                "keepalives_count": 5,
            }

    def connect(self):
        return psycopg2.connect(**self.params)

    def run_sql_file(self, sql_file_path):
        with open(sql_file_path, "r") as file:
            sql = file.read()
        self.run_sql(sql)

    def run_sql(self, sql):
        try:
            with self.connect() as conn:
                with conn.cursor() as cur:
                    cur.execute(sql)
        except psycopg2.Error as e:
            logging.error(f"An error occurred while executing SQL: {str(e)}")
            raise e

    def restore_pg_dump(self, dump_file_path):
        with open(dump_file_path, "rb") as pg_dump_file:
            try:
                result = subprocess.run(
                    [
                        "pg_restore",
                        "--dbname=" + self.params["dbname"],
                        "--username=" + self.params["user"],
                        "--host=" + self.params["host"],
                        "--port=" + self.params["port"],
                        "--no-acl",
                        "--no-owner",
                        "--exit-on-error",
                    ],
                    stdin=pg_dump_file,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                )
                if result.returncode != 0:
                    error_message = result.stderr.decode("utf-8")
                    logging.error(f"pg_restore failed with error: {error_message}")
                    raise Exception(f"pg_restore failed: {error_message}")
                logging.info(
                    f"SUCCESS {dump_file_path} pg_restore db={self.params['dbname']}"
                )
            except FileNotFoundError as e:
                logging.error(f"Dump file not found: {dump_file_path}")
                raise e
            except subprocess.CalledProcessError as e:
                logging.error(f"An error occurred while restoring the dump: {str(e)}")
                raise e
            except Exception as e:
                logging.error(
                    f"An error occurred during the database import of {dump_file_path}: {str(e)}"
                )
                logging.error(
                    f"FAIL {dump_file_path} pg_restore db={self.params['dbname']}"
                )
                raise e

    def load_psql_file(self, sql_file_path):
        # It would be safer to load the contents in this file into strings and run the sql through psycopg2,
        # but that would take time to implement and test. And the data file needs to run in pg_restore so we can't remove the use of subprocesses.
        # Only run this on trusted files.
        command = [
            "psql",
            "--dbname=" + self.params["dbname"],
            "--username=" + self.params["user"],
            "--host=" + self.params["host"],
            "--port=" + self.params["port"],
            "-v",
            "ON_ERROR_STOP=1",
            "-f",
            sql_file_path,
        ]

        try:
            result = subprocess.run(
                command,
                # stdin=sql_file_path,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            if result.returncode != 0:
                logging.error(f"{command} returned {result.returncode}")
                raise Exception(result.stderr.decode("utf-8"))
            logging.debug(f" SUCCESS {sql_file_path} psql db={self.params['dbname']}")
            return result
        except Exception as e:
            logging.error(
                f"FAIL {command} {sql_file_path} psql db={self.params['dbname'], self.params['user'], self.params['host'], self.params['port']}"
            )
            logging.error(
                f"An error occurred during the database import of {sql_file_path}: {str(e)}"
            )
            raise e

    def db_exists(self, dbname: str) -> bool:
        """
        Check if a given PostgreSQL database exists.

        :param dbname: Name of the database to check.
        :return: True if the database exists, otherwise False.
        """
        try:
            with self.connect() as conn:
                with conn.cursor() as cur:
                    # Use EXISTS(...) for a direct boolean result
                    cur.execute(
                        "SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = %s)",
                        (dbname,),
                    )
                    result = cur.fetchone()
                    if result is None:
                        return False
                    exists = result[0]
                    return bool(exists)
        except psycopg2.Error as e:
            logging.exception(
                f"An error occurred while checking if database '{dbname}' exists: {str(e)}"
            )
            return False

    def table_exists(self, table_name) -> bool:
        try:
            # Connect to the database server
            logging.info(
                f"Connecting to '{self.params['dbname']}' db to see if table '{table_name}' exists..."
            )
            with self.connect() as conn:
                result = False
                # Check if the table already exists
                with conn.cursor() as cur:
                    cur.execute(
                        "SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = %s",
                        (table_name,),
                    )
                    result = bool(cur.fetchone())
                    logging.debug(
                        f"SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '{table_name}' returned: {result}"
                    )

                return result

        except psycopg2.Error as e:
            logging.error(f"An error occurred while checking for the table: {str(e)}")
            return e

    def create_database(self, new_db_name):
        """
        Create a PostgreSQL database with the given parameters.
        :param new_db_name: Name of the database to create
        """
        try:
            with self.connect() as conn:
                conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
                with conn.cursor() as cur:
                    cur.execute(f"CREATE DATABASE {new_db_name}")
                    logging.info(f"Database '{new_db_name}' created successfully.")

        except psycopg2.DatabaseError as error:
            logging.error(f"Database error occurred: {error}")
            raise Exception(f"Database error occurred: {error}")
        except psycopg2.Error as e:
            logging.error(
                f"An error occurred while creating the database '{new_db_name}': {str(e)}"
            )
            raise e
        except Exception as error:
            logging.exception(f"An unexpected error occurred: {error}")
            raise Exception(f"An unexpected error occurred: {error}")

    def drop_database(self, new_db_name):
        """
        Delete a PostgreSQL database safely
        """
        try:
            connection = self.connect()
            connection.autocommit = (
                True  # Set autocommit to True to avoid transaction block
            )
            cursor = connection.cursor()

            # SQL to terminate connections and drop database
            terminate_connections_query = f"""
                SELECT pg_terminate_backend(pid) 
                FROM pg_stat_activity 
                WHERE datname = '{new_db_name}'
                AND pid <> pg_backend_pid();
                """
            cursor.execute(terminate_connections_query)

            # Drop the database
            drop_query = f"DROP DATABASE IF EXISTS {new_db_name}"
            cursor.execute(drop_query)

            logging.info(f"Database '{new_db_name}' created successfully.")
            logging.info(f"Successfully dropped database: {new_db_name}")

        except psycopg2.DatabaseError as error:
            logging.error(f"Database error occurred: {error}")
            raise Exception(f"Database error occurred: {error}")

        except Exception as error:
            logging.error(f"Failed to delete database {new_db_name}: {str(error)}")
            raise Exception(f"An unexpected error occurred: {error}")

        finally:
            # Close the cursor and connection
            if cursor:
                cursor.close()
            if connection:
                connection.close()

    def copy_data_to_table(self, csv_file_path, table_name, columns):
        try:
            # Construct the COPY command
            columns_str = ", ".join(columns)
            copy_command = f"COPY {table_name} ({columns_str}) FROM '{csv_file_path}' DELIMITER ',' CSV HEADER;"
            logging.info(copy_command)

            # Construct the psql command
            psql_command = [
                "psql",
                "--dbname=" + self.params["dbname"],
                "--username=" + self.params["user"],
                "--host=" + self.params["host"],
                "--port=" + self.params["port"],
                "-v",
                "ON_ERROR_STOP=1",
                "-c",
                copy_command,
            ]

            # Execute the psql command
            subprocess.run(psql_command, check=True)
            logging.info(f"Data copied to table {table_name} successfully.")

        except subprocess.CalledProcessError as e:
            print(psql_command)
            logging.error(f"An error occurred while copying data: {str(e)}")
            raise e
