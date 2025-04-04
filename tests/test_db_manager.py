import pytest
import logging
import os
from unittest.mock import patch, MagicMock, mock_open, call
from utils.database_manager import DatabaseManager
import subprocess  # Add this import statement
from psycopg2 import Error as Psycopg2Error, OperationalError

@pytest.fixture
def db_params():
    return {
        "host": "localhost",
        "port": "5432",
        "dbname": "testdb",
        "user": "testuser",
        "password": "testpass"
    }

@pytest.fixture
def db_manager(db_params):
    return DatabaseManager(**db_params)

def test_init_missing_password():
    with pytest.raises(Exception, match="Please set PGPASSWORD environment variable"):
        DatabaseManager("localhost", "5432", "testdb", "testuser", "")

def test_init_missing_parameters():
    with pytest.raises(Exception, match="Please set PGPASSWORD environment variable"):
        DatabaseManager(None, "5432", "testdb", "testuser", "testpass")

def test_init_successful(db_params):
    manager = DatabaseManager(**db_params)
    assert manager.params["host"] == db_params["host"]
    assert manager.params["dbname"] == db_params["dbname"]

@patch("psycopg2.connect")
def test_connect_success(mock_connect, db_manager):
    db_manager.connect()
    mock_connect.assert_called_once_with(**db_manager.params)

@patch("psycopg2.connect", side_effect=Exception("Connection failed"))
def test_connect_failure(mock_connect, db_manager):
    with pytest.raises(Exception, match="Connection failed"):
        db_manager.connect()

from unittest.mock import patch, mock_open, MagicMock

@patch("builtins.open", new_callable=mock_open, read_data="SELECT * FROM test;")
@patch("psycopg2.connect")
def test_run_sql_file(mock_connect, mock_file, db_manager):
    # Mock cursor and connection
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_connect.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor
    mock_conn.__enter__.return_value = mock_conn

    # Assuming db_manager is an instance of DatabaseManager
    db_manager.run_sql_file("test.sql")

    mock_file.assert_called_once_with("test.sql", "r")
    mock_cursor.execute.assert_called_once_with("SELECT * FROM test;")

@patch("psycopg2.connect")
def test_run_sql_fetch_all(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.fetchall.return_value = [("row1",), ("row2",)]
    mock_connect.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor
    mock_conn.__enter__.return_value = mock_conn

    result = db_manager.run_sql("SELECT * FROM test;", fetch_all=True)
    mock_cursor.execute.assert_called_once_with("SELECT * FROM test;")
    assert result == [("row1",), ("row2",)]

@patch("psycopg2.connect")
def test_run_sql_fetch_one(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.fetchone.return_value = ("value1", "value2")
    mock_cursor.description = (("col1",), ("col2",))
    mock_connect.return_value = mock_conn
    mock_conn.__enter__.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    result = db_manager.run_sql("SELECT * FROM test;", fetch_one=True, header=True)
    mock_cursor.execute.assert_called_once_with("SELECT * FROM test;")
    assert result == {"col1": "value1", "col2": "value2"}

@patch("psycopg2.connect")
def test_run_sql_no_fetch(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_connect.return_value = mock_conn
    mock_conn.__enter__.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    result = db_manager.run_sql("INSERT INTO test VALUES (1);")
    mock_cursor.execute.assert_called_once_with("INSERT INTO test VALUES (1);")
    assert result is None


@patch("psycopg2.connect")
def test_run_sql_error(mock_connect, db_manager, caplog):
    caplog.set_level(logging.ERROR)
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.execute.side_effect = Psycopg2Error("SQL error")
    mock_connect.return_value = mock_conn
    mock_conn.__enter__.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    with pytest.raises(Psycopg2Error, match="SQL error"):
        db_manager.run_sql("BAD SQL;")

    assert any("An error occurred while executing SQL:" in message for message in caplog.messages)

@patch("psycopg2.connect")
def test_insert_data_with_query_success(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.rowcount = 5
    mock_connect.return_value = mock_conn
    mock_conn.__enter__.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    query = "INSERT INTO test_table (col1, col2) VALUES (%s, %s)"
    flattened_batch = ("val1", "val2")
    rows_written = db_manager.insert_data_with_query(query, flattened_batch)
    mock_cursor.execute.assert_called_once_with(query, flattened_batch)
    assert rows_written == 5


@patch("psycopg2.connect")
def test_insert_data_with_query_retry(mock_connect, db_manager, caplog):
    caplog.set_level(logging.ERROR)
    
    # Create the mocks for the second successful connection
    mock_conn_2 = MagicMock()
    mock_cursor_2 = MagicMock()
    mock_cursor_2.rowcount = 1

    # Set up the side_effect after we've defined mock_conn_2
    mock_connect.side_effect = [
        OperationalError("OperationalError"),  # first call fails
        mock_conn_2                             # second call succeeds
    ]

    # Configure the mocks to act as context managers
    mock_conn_2.__enter__.return_value = mock_conn_2
    mock_conn_2.cursor.return_value.__enter__.return_value = mock_cursor_2

    query = "INSERT INTO test_table (col1) VALUES (%s)"
    flattened_batch = ("val1",)

    rows_written = db_manager.insert_data_with_query(query, flattened_batch)

    # Now we check the logs
    assert any("Database Connection [InterfaceError or OperationalError]" in record.message for record in caplog.records), \
        "Expected an error log for OperationalError, but it was not found."
    assert rows_written == 1, "Expected rows_written to be 1, but got a different value."


@patch("builtins.open", new_callable=mock_open)
@patch("subprocess.run")
def test_restore_pg_dump_success(mock_subprocess, mock_file, db_manager):
    # Mock the subprocess.run call to simulate a successful restore
    mock_subprocess.return_value = MagicMock(returncode=0)

    # Define the dump file path
    dump_file_path = "mock_dump_file.sql"
    
    # Call the method to restore the dump
    db_manager.restore_pg_dump(dump_file_path)

    # Assert that open was called with the correct file path and mode
    mock_file.assert_called_once_with(dump_file_path, "rb")

    # Assert that subprocess.run was called with the correct arguments
    mock_subprocess.assert_called_once_with(
        [
            "pg_restore",
            "--dbname=" + db_manager.params["dbname"],
            "--user=" + db_manager.params["user"],
            "--host=" + db_manager.params["host"],
            "--port=" + db_manager.params["port"],
            "--no-acl",
            "--no-owner",
            "--exit-on-error",
        ],
        stdin=mock_file(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

@patch("builtins.open", new_callable=mock_open)
@patch("subprocess.run")
def test_restore_pg_dump_failure(mock_subprocess, mock_file, db_manager, caplog):
    # Mock the subprocess.run call to simulate a failed restore
    mock_subprocess.return_value = MagicMock(returncode=1, stderr=b"pg_restore: error")

    # Define the dump file path
    dump_file_path = "mock_dump_file.sql"
    
    # Call the method to restore the dump and expect an exception
    with pytest.raises(Exception, match="pg_restore failed: pg_restore: error"):
        db_manager.restore_pg_dump(dump_file_path)

    # Assert that open was called with the correct file path and mode
    mock_file.assert_called_once_with(dump_file_path, "rb")

    # Assert that subprocess.run was called with the correct arguments
    mock_subprocess.assert_called_once_with(
        [
            "pg_restore",
            "--dbname=" + db_manager.params["dbname"],
            "--user=" + db_manager.params["user"],
            "--host=" + db_manager.params["host"],
            "--port=" + db_manager.params["port"],
            "--no-acl",
            "--no-owner",
            "--exit-on-error",
        ],
        stdin=mock_file(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    # Check the logs for the expected error message
    assert any("pg_restore failed with error: pg_restore: error" in record.message for record in caplog.records), \
        "Expected an error log for pg_restore failure, but it was not found."

@patch("subprocess.run")
def test_load_psql_file_success(mock_subprocess, db_manager):
    mock_subprocess.return_value.returncode = 0
    result = db_manager.load_psql_file("test.sql")
    mock_subprocess.assert_called_once()
    assert result is not None

@patch("subprocess.run", return_value=MagicMock(returncode=1, stderr=b"PSQL error"))
def test_load_psql_file_failure(mock_subprocess, db_manager):
    with pytest.raises(Exception, match="PSQL error"):
        db_manager.load_psql_file("test.sql")

@patch("psycopg2.connect")
def test_db_exists_true(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.fetchone.return_value = (1,)
    mock_connect.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    assert db_manager.db_exists("existing_db") is True

@patch("psycopg2.connect")
def test_db_exists_false(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.fetchone.return_value = None
    mock_connect.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    assert db_manager.db_exists("non_existing_db") is False

@patch("psycopg2.connect", side_effect=Exception("Check DB error"))
def test_db_exists_error(mock_connect, db_manager):
    err = db_manager.db_exists("some_db")
    assert isinstance(err, Exception)
    assert str(err) == "Check DB error"

@patch("psycopg2.connect")
def test_table_exists_true(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.fetchone.return_value = (1,)
    mock_connect.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    assert db_manager.table_exists("test_table") is True

@patch("psycopg2.connect")
def test_db_exists_false(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_cursor.fetchone.return_value = None

    mock_connect.return_value = mock_conn
    # Make the connection mock act as a context manager
    mock_conn.__enter__.return_value = mock_conn
    # Make the cursor mock act as a context manager
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    assert db_manager.db_exists("non_existing_db") is False


@patch("psycopg2.connect", side_effect=Exception("Check DB error"))
def test_db_exists_error(mock_connect, db_manager):
    with pytest.raises(Exception, match="Check DB error"):
        db_manager.db_exists("some_db")

@patch("psycopg2.connect")
def test_create_database_success(mock_connect, db_manager):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_connect.return_value = mock_conn
    mock_conn.__enter__.return_value = mock_conn
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor

    db_manager.create_database("new_db")
    mock_cursor.execute.assert_called_once_with("CREATE DATABASE new_db")

@patch("psycopg2.connect", side_effect=Exception("Database error occurred: TestError"))
def test_create_database_error(mock_connect, db_manager):
    with pytest.raises(Exception, match="Database error occurred: TestError"):
        db_manager.create_database("new_db")

# @patch("subprocess.run")
# def test_copy_data_to_table_success(mock_subprocess, db_manager):
#     mock_subprocess.return_value.check_returncode = lambda: 0
#     db_manager.copy_data_to_table("data.csv", "test_table", ["col1", "col2"])
#     assert mock_subprocess.call_count == 1

# @patch("subprocess.run", side_effect=Exception("Copy error"))
# def test_copy_data_to_table_failure(mock_subprocess, db_manager):
#     with pytest.raises(Exception, match="Copy error"):
#         db_manager.copy_data_to_table("data.csv", "test_table", ["col1", "col2"])

@patch("subprocess.run")
def test_copy_data_to_table_success(mock_subprocess, db_manager, caplog):
    # Mock the subprocess.run call to simulate a successful copy
    mock_subprocess.return_value = MagicMock(returncode=0)

    # Define the CSV file path, table name, and columns
    csv_file_path = "mock_data.csv"
    table_name = "test_table"
    columns = ["col1", "col2", "col3"]

    # Call the function
    with caplog.at_level(logging.INFO):
        db_manager.copy_data_to_table(csv_file_path, table_name, columns)

    # Construct the expected COPY command and psql command
    columns_str = ', '.join(columns)
    copy_command = f"COPY {table_name} ({columns_str}) FROM '{csv_file_path}' DELIMITER ',' CSV HEADER;"
    psql_command = [
        "psql",
        "--dbname=" + db_manager.params["dbname"],
        "--user=" + db_manager.params["user"],
        "--host=" + db_manager.params["host"],
        "--port=" + db_manager.params["port"],
        "-v",
        "ON_ERROR_STOP=1",
        '-c', copy_command
    ]

    # Assert that subprocess.run was called with the correct arguments
    mock_subprocess.assert_called_once_with(psql_command, check=True)

    # Assert that the success message was logged
    assert f"Data copied to table {table_name} successfully." in caplog.text

@patch("subprocess.run", side_effect=subprocess.CalledProcessError(1, "psql"))
def test_copy_data_to_table_failure(mock_subprocess, db_manager, caplog):
    # Define the CSV file path, table name, and columns
    csv_file_path = "mock_data.csv"
    table_name = "test_table"
    columns = ["col1", "col2", "col3"]

    # Call the function and expect an exception
    with pytest.raises(subprocess.CalledProcessError):
        db_manager.copy_data_to_table(csv_file_path, table_name, columns)

    # Construct the expected COPY command and psql command
    columns_str = ', '.join(columns)
    copy_command = f"COPY {table_name} ({columns_str}) FROM '{csv_file_path}' DELIMITER ',' CSV HEADER;"
    psql_command = [
        "psql",
        "--dbname=" + db_manager.params["dbname"],
        "--user=" + db_manager.params["user"],
        "--host=" + db_manager.params["host"],
        "--port=" + db_manager.params["port"],
        "-v",
        "ON_ERROR_STOP=1",
        '-c', copy_command
    ]

    # Assert that subprocess.run was called with the correct arguments
    mock_subprocess.assert_called_once_with(psql_command, check=True)

    # Assert that the error message was logged
    assert "An error occurred while copying data: Command 'psql' returned non-zero exit status 1." in caplog.text