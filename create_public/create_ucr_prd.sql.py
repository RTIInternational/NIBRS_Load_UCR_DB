def get_sql_string(password):
    sql_string = f"""
        DO $$
        BEGIN
            -- Check if user exists
            IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'ucr_prd') THEN
                -- Create user if it doesn't exist
                CREATE USER ucr_prd WITH PASSWORD '{password}';
                RAISE NOTICE 'User ucr_prd created successfully';
            ELSE
                RAISE NOTICE 'User ucr_prd already exists';
            END IF;

            -- Grant read-only access to all existing tables in public schema
            GRANT USAGE ON SCHEMA public TO ucr_prd;
            GRANT SELECT ON ALL TABLES IN SCHEMA public TO ucr_prd;
            
            -- Grant read-only access to future tables
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ucr_prd;
        END
        $$;

    """
    return sql_string
