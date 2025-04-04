def get_sql_string(dbname):
    sql_string = f"""
        GRANT CONNECT ON DATABASE {dbname} TO readaccess;
        GRANT USAGE ON SCHEMA public TO readaccess;
        GRANT USAGE ON SCHEMA {dbname} TO readaccess;
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess;
        GRANT SELECT ON ALL TABLES IN SCHEMA {dbname} TO readaccess;

        GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess;
        GRANT SELECT ON all TABLES IN SCHEMA {dbname} TO readaccess;
        """

    return sql_string
