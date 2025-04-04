def get_sql_string(dbname):
    sql_string = f"""
        GRANT CONNECT ON DATABASE {dbname} TO ucr_read_only_prd;
        GRANT USAGE ON SCHEMA {dbname} TO ucr_read_only_prd;
        GRANT SELECT ON ALL TABLES IN SCHEMA {dbname} TO ucr_read_only_prd;
        
        GRANT USAGE ON SCHEMA public TO ucr_read_only_prd;
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO ucr_read_only_prd;
        
        --- UCR PRD user only has read-only access 
        ---    Because we don't need to write to the database, we can grant read-only access to the ucr_prd user.
        ---    ucr_prod role access can be changed here 
        --- 
        GRANT CONNECT ON DATABASE {dbname} TO ucr_prd;
        GRANT USAGE ON SCHEMA {dbname} TO ucr_prd;
        GRANT SELECT ON ALL TABLES IN SCHEMA {dbname} TO ucr_prd;
        
        GRANT USAGE ON SCHEMA public TO ucr_read_only_prd;
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO ucr_prd;
        
        """

    return sql_string
