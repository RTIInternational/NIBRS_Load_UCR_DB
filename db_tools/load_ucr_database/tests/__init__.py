import psycopg2
from psycopg2 import sql
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import subprocess
import logging
import time
from typing import Optional, List, Dict, Any, Tuple, Union
from pathlib import Path

class DatabaseManager:
    """
    Manages database connections and operations with enhanced error handling,
    automatic reconnection, and proper transaction management.
    """
    
    def __init__(self, host: str, port: str, dbname: str, user: str, password: str):
        """
        Initialize database manager with connection parameters and keepalive settings.
        
        Args:
            host: Database host
            port: Database port
            dbname: Database name
            user: Database user
            password: Database password
            
        Raises:
            Exception: If required parameters are missing
        """
        if not password or password == "":
            logging.error("PGPASSWORD environment variable not set")
            raise ValueError("Please set PGPASSWORD environment variable")
        elif not all([host, port, dbname, user, password]):
            logging.error("All parameters (host, port, user, password, database_name) must be provided.")
            raise ValueError("Missing required database connection parameters")
            
        self.params = {
            "host": host,
            "port": port,
            "dbname": dbname,
            "user": user,
            "password": password,
            # Keepalive settings to prevent connection timeouts
            "keepalives": 1,
            "keepalives_idle": 1200,
            "keepalives_interval": 5,
            "keepalives_count": 5,
        }
        self._conn = None

    def connect(self) -> psycopg2.extensions.connection:
        """
        Create a new database connection with retry logic.
        
        Returns:
            psycopg2.extensions.connection: Database connection
            
        Raises:
            psycopg2.Error: If connection fails after retries
        """
        retry_count = 0
        max_retries = 3
        retry_delay = 5  # seconds
        
        while retry_count < max_retries:
            try:
                conn = psycopg2.connect(**self.params)
                return conn
            except (psycopg2.OperationalError, psycopg2.InterfaceError) as e:
                retry_count += 1
                if retry_count == max_retries:
                    logging.error(f"Failed to connect after {max_retries} attempts: {str(e)}")
                    raise
                logging.warning(f"Connection attempt {retry_count} failed, retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)

    def run_sql(self, sql_query: str, 
                fetch_all: bool = False, 
                fetch_one: bool = False, 
                header: bool = False,
                params: Optional[tuple] = None) -> Optional[Union[List[tuple], Dict[str, Any], tuple]]:
        """
        Execute SQL query with enhanced error handling and result formatting.
        
        Args:
            sql_query: SQL query to execute
            fetch_all: Return all results
            fetch_one: Return single result
            header: Include column headers in result
            params: Query parameters for parameterized queries
            
        Returns:
            Query results based on fetch parameters
        """
        try:
            with self.connect() as conn:
                with conn.cursor() as cur:
                    cur.execute(sql_query, params)
                    
                    if fetch_one:
                        result = cur.fetchone()
                        if header and result:
                            colnames = [desc[0] for desc in cur.description]
                            return dict(zip(colnames, result))
                        return result
                    
                    if fetch_all:
                        return cur.fetchall()
                    
                    return None
                    
        except psycopg2.Error as e:
            logging.error(f"SQL execution error: {str(e)}")
            logging.error(f"Query: {sql_query}")
            raise

    def insert_data_with_query(self, query: str, data: tuple) -> Optional[int]:
        """
        Insert data with retry logic and proper transaction handling.
        
        Args:
            query: SQL insert query
            data: Data to insert
            
        Returns:
            Number of rows inserted or None on failure
        """
        max_retries = 5
        retry_delay = 5
        
        for attempt in range(max_retries):
            try:
                with self.connect() as conn:
                    with conn.cursor() as cur:
                        cur.execute(query, data)
                        conn.commit()
                        return cur.rowcount
                        
            except (psycopg2.InterfaceError, psycopg2.OperationalError) as e:
                if attempt < max_retries - 1:
                    logging.warning(f"Attempt {attempt + 1} failed, retrying in {retry_delay} seconds...")
                    time.sleep(retry_delay)
                else:
                    logging.error(f"Failed to insert data after {max_retries} attempts: {str(e)}")
                    raise
                    
            except Exception as e:
                logging.error(f"Error executing insert: {str(e)}")
                logging.error(f"Query: {query}")
                raise

    def load_psql_file(self, sql_file_path: Union[str, Path]) -> subprocess.CompletedProcess:
        """
        Execute SQL file using psql command with enhanced security and error handling.
        
        Args:
            sql_file_path: Path to SQL file
            
        Returns:
            subprocess.CompletedProcess: Command result
            
        Raises:
            Exception: If command fails
        """
        command = [
            "psql",
            f"--dbname={self.params['dbname']}",
            f"--user={self.params['user']}",
            f"--host={self.params['host']}",
            f"--port={self.params['port']}",
            "-v", "ON_ERROR_STOP=1",
            "-f", str(sql_file_path),
        ]

        try:
            result = subprocess.run(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,  # Raise CalledProcessError if command fails
                text=True    # Return strings instead of bytes
            )
            logging.info(f"Successfully executed SQL file: {sql_file_path}")
            return result
            
        except subprocess.CalledProcessError as e:
            logging.error(f"Failed to execute SQL file: {sql_file_path}")
            logging.error(f"Error: {e.stderr}")
            raise

    def create_database(self, new_db_name: str) -> None:
        """
        Create a new database with proper isolation level handling.
        
        Args:
            new_db_name: Name of database to create
        """
        try:
            with self.connect() as conn:
                conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
                with conn.cursor() as cur:
                    create_db_query = sql.SQL("CREATE DATABASE {}").format(
                        sql.Identifier(new_db_name)
                    )
                    cur.execute(create_db_query)
                    logging.info(f"Database '{new_db_name}' created successfully")
                    
        except psycopg2.Error as e:
            logging.error(f"Failed to create database {new_db_name}: {str(e)}")
            raise

    def copy_data_to_table(self, csv_file_path: Union[str, Path], 
                          table_name: str, 
                          columns: List[str]) -> None:
        """
        Copy data from CSV file to database table using COPY command.
        
        Args:
            csv_file_path: Path to CSV file
            table_name: Target table name
            columns: List of column names
        """
        try:
            columns_str = ', '.join(columns)
            copy_command = f"COPY {table_name} ({columns_str}) FROM STDIN WITH CSV HEADER"
            
            with self.connect() as conn:
                with conn.cursor() as cur:
                    with open(csv_file_path, 'r') as f:
                        cur.copy_expert(copy_command, f)
                    logging.info(f"Successfully copied data to {table_name}")
                    
        except (psycopg2.Error, IOError) as e:
            logging.error(f"Failed to copy data to {table_name}: {str(e)}")
            raise

    def restore_pg_dump(self, dump_file_path: Union[str, Path]) -> subprocess.CompletedProcess:
        """
        Restore database from pg_dump file.
        
        Args:
            dump_file_path: Path to dump file
            
        Returns:
            subprocess.CompletedProcess: Command result
        """
        try:
            command = [
                "pg_restore",
                f"--dbname={self.params['dbname']}",
                f"--user={self.params['user']}",
                f"--host={self.params['host']}",
                f"--port={self.params['port']}",
                "--no-acl",
                "--no-owner",
                "--exit-on-error",
                str(dump_file_path)
            ]
            
            result = subprocess.run(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,
                text=True
            )
            logging.info(f"Successfully restored database from {dump_file_path}")
            return result
            
        except subprocess.CalledProcessError as e:
            logging.error(f"Failed to restore database from {dump_file_path}")
            logging.error(f"Error: {e.stderr}")
            raise