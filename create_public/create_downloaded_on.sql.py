def get_sql_string(downloaded_on_date):
    sql_string = f"""
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'downloaded_on'
    ) THEN
        CREATE TABLE public.downloaded_on (
            id int4 NOT NULL,
            "date" date NULL DEFAULT CURRENT_DATE,
            CONSTRAINT downloaded_on_pkey PRIMARY KEY (id)
        );
    END IF;
END $$;

-- Data for Name: downloaded_on; Type: TABLE DATA; Schema: public; Owner: postgres
--
-- TODO move this into it's own .sql file and make it so it can be set via env or datetime.now
DO $$ BEGIN
    IF EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'downloaded_on'
    ) THEN
        INSERT INTO public.downloaded_on VALUES (1, '{downloaded_on_date}') ON CONFLICT (id) DO NOTHING;
    END IF;
END $$;"""
    return sql_string
