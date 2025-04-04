# Database Export Loader Script

This script is designed to automate the process of loading a database export located externally and applying view .sql files to the database. The export is expected to be in the most recent folder in the 030_Input_Data folder on the project share, and it will be copied to a corresponding directory in `data/` . Additionally, the script relies on configuration files: `config.yml` for specifying paths and `.env` for providing database credentials.

It uses two database connections: one to an existing database and one to a new database to be imported.  The script also supports running a specific SQL file, skipping certain steps, and enabling verbose logging through command-line arguments.

## Database Prerequisites

Before using this script, ensure you have the following prerequisites in place:

1. A PostgreSQL database server that you want to import data into.
   1. This should NOT have a database called ucr_prd, because that is the db_name the CJIS exports use. 

The script is used to import to a database from a set of SQL files.

## Install

The script can be run with Docker or directly with Python.

### Run with Docker

Running with Docker includes all dependencies. The following command will build the image:

```bash
docker compose build
```

### Run natively

If running natively with Python, you will also need to install the following CLI utilities:

- `psql` (postgresql-client) version matching the version of the database in the provided export 
- `pg_restore` 

Install Python dependencies (Python 3.6 or higher):

```bash
pip install -r requirements.txt
```

## Configuration

### 1. Database Export

- The database export should be placed in the project data folder. We recommend inside another folder named after the delivery date. For example:
  `db_tools/load_ucr_database/data/feb_25/`

- The export consists of 3 files, pre, data, and post.
  - Pre creates the database & table schema
    - e.g. `db_tools/load_ucr_database/data/feb_25/ucr_stat_2024-pre.sql`
  - - Data is a compressed binary export of the db contents
    - e.g. `db_tools/load_ucr_database/data/feb_25/ucr_stat_2024-data.dmp.gz`
  - Post wraps things up, creates indexes etc.
    - e.g. `db_tools/load_ucr_database/data/feb_25/ucr_stat_2024-pre.sql`

### 2. Credentials

- Provide your PostgreSQL database credentials in a `.env` file in the same directory as load_nibrs_ucr_db.py. The script requires the following environment variables:


- PGHOST: The hostname of your PostgreSQL server
- PGPORT: The port number to connect to your PostgreSQL server (default: 5432)
- PGUSER: The username to connect to your PostgreSQL server (default: postgres)
- PGPASSWORD: The password for the postgres user
- PGDBNAME: The name of the postgres database (default: postgres)
- EXISTING_PGDATABASE: The name of the existing database to connect to (default: postgres)
- IMPORT_PGDATABASE: The name of the new database to be imported (default: ucr_prd)
- DATADIR: The directory where your data is stored (default: ./data)
- BASEPATH: The base path for running the script (default: ./)
- UCR_PRD_PASSWORD: Password for the ucr_prd user
- UCR_READ_ONLY_PRD_PASSWORD: Password for the ucr_read_only_prd user
- NIBRS_ANALYST_PASSWORD: Password for the nibrs_analyst user
- DOWNLOADED_ON: Date the data was downloaded (format: YYYY-MM-DD)


`EXISTING_PGDATABASE` is used to connect to the Postgres instance to check for the existence of the imported database, and create it if necessary. `IMPORT_PGDATABASE` is the name of the database that will be created and data will be imported into.

### 3. Configuration Paths

- Review the `config.yml` file to ensure that the paths in are correctly configured for your setup. Modify the `config.yml` file if necessary.

### 4. SQL Views
- In order to convert the delivered db structure to the structure the estimation system expects SQL to create views and materialized views are located placed in the `data/create-public` directory. These need to be run in order, as specified in the `config.yml` file.

## Steps

Follow these steps to use the script:

1. Download the database export to the local data directory.
   1. e.g. from [May 2023](smb://rtpnfil02.rti.ns/0218750_NIBRS/030_InputData/2023_05/NIBRS) and copy it to the `data/may_23` directory.
   2. Check the pre and post files, you may need to make minor edits
      1. For example: Comment out the `CREATE DATABASE` line in dbname-post.sql file if present
2. Delete or rename the `ucr_prd` if it already exists
   1. Double check the "pre" file to confirm the name of the incoming filename in case it's changed
   2. The export relies on the database name that it was created with and changing the name has could cause unexpected problems.

3. Set the PostgreSQL database credentials in the `.env` file. You can validate these credentials using your tool of choice. `psql`, `pgadmin`, or `dbeaver` are popular options.

4. Check the `config.yaml` file to ensure the paths are correctly configured for your environment. Make any necessary modifications as needed.

5. Run load_nibrs_ucr_db.py in one of two ways
   1. Docker Run `docker-compose up -d db_importer; docker-compose logs -f` to import the database.
      1. This will allow you to see the logs of the process as it runs or dismiss using cmd-c (or ctrl-c in windows)
   
   2. Alternatively, you can create a python environment, run `pip install -r requirements.txt` and then run the `load_nibrs_ucr_db.py` script to import the data from the exported file and apply the view SQL files. You can run the script using the following command:

   ```bash
   python load_nibrs_ucr_db.py
   ```

   The script will use the `.env` file for database credentials and the `config.yml` file for file paths.

## Command-Line Arguments

- `--config PATH`: Path to .env file (default: .env)
- `--file_name FILE`: Run a specific SQL file only
- `--skip_setup`: Skip the extra setup file
- `--skip_pre`: Skip the data-pre file
- `--skip_data`: Skip the data file
- `--skip_post`: Skip the data-post file 
- `--skip_public`: Skip the public schema creation steps
- `--skip_user_access`: Skip setting the user access creation steps
- `--drop_db`: Drop the database after a failed import to start over
- `--verbose`: Enable verbose logging

Example usage with command-line arguments:

```bash
python load_nibrs_ucr_db.py --config myconfig.env --file_name mydata.sql --verbose
```

To run command line arguments from Docker modify the command in the docker-compose.yml files `command: bash -c "python load_nibrs_ucr_db.py"` or comment it out and connect to the container and run the command from it's command prompt.

## Testing 

The tests directory contains it's own config.yml file and data, create_public folders. This will create a small test database. 

The test.env.sample file contains details for a local database running on docker.


```bash
python load_nibrs_ucr_db.py --config test.env.sample 
```
or 
```
docker compose up -d test_database; 
docker compose run --rm db_importer python load_nibrs_ucr_db.py  --config test.env.sample 
``` 