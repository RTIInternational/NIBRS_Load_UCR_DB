def get_sql_string(password):
    sql_string = f"""DO $$ BEGIN
        IF NOT EXISTS (
            SELECT FROM pg_roles WHERE rolname = 'readaccess'
        ) THEN
            CREATE ROLE readaccess;
        END IF;
    END $$;

    DO $$ BEGIN
        IF NOT EXISTS (
            SELECT FROM pg_roles WHERE rolname = 'nibrs_analyst'
        ) THEN
            CREATE USER nibrs_analyst WITH PASSWORD '{password}';
        END IF;
    END $$;

    GRANT readaccess TO nibrs_analyst;"""
    return sql_string
