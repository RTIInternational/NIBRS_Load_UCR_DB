--
-- PostgreSQL database dump
--

-- Dumped from database version 10.21
-- Dumped by pg_dump version 14.6 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: nibrs_incident; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_incident'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_incident AS
        SELECT nibrs_incident.incident_id,
            nibrs_incident.form_month_id,
            nibrs_incident.incident_number,
            (nibrs_incident.incident_date)::timestamp without time zone AS incident_date,
            date_part('year'::text, nibrs_incident.incident_date) AS data_year,
            nibrs_incident.is_reported_date,
            nibrs_incident.incident_hour,
            nibrs_incident.cleared_exceptionally_code,
            nibrs_incident.cleared_exceptionally_date,
            nibrs_incident.did,
            nibrs_incident.is_cargo_theft,
            nibrs_incident.agency_id,
            nibrs_incident.judicial_district,
            -- nibrs_incident.prenibrs_code, -- removed in the April 2025 delivery of the DY2024 UCR Database
            nibrs_cleared_except.cleared_except_id,
            nibrs_cleared_except.cleared_except_code,
            nibrs_cleared_except.cleared_except_name,
            nibrs_cleared_except.cleared_except_desc,
            nibrs_cleared_except.sort_order,
            nibrs_incident.cleared_exceptionally_date AS cleared_except_date,
                CASE
                    WHEN (nibrs_incident.is_cargo_theft IS TRUE) THEN 'Y'::bpchar
                    WHEN (nibrs_incident.is_cargo_theft IS FALSE) THEN 'N'::bpchar
                    ELSE NULL::bpchar
                END AS cargo_theft_flag,
                CASE
                    WHEN (nibrs_incident.is_reported_date IS TRUE) THEN 'R'::bpchar
                    WHEN (nibrs_incident.is_reported_date IS FALSE) THEN ''::bpchar
                    ELSE NULL::bpchar
                END AS report_date_flag,
            nibrs_incident.form_month_id AS nibrs_month_id
        FROM (ucr_prd.nibrs_incident
            JOIN public.nibrs_cleared_except ON ((nibrs_cleared_except.cleared_except_code = nibrs_incident.cleared_exceptionally_code)))
        WITH DATA;
    END IF;
END $$;


--
-- Name: ix_13; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_13' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX ix_13 ON public.nibrs_incident USING btree (data_year, incident_id);
    END IF;
END $$;
--
-- Name: ix_25; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_25' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX ix_25 ON public.nibrs_incident USING btree (incident_date);
    END IF;
END $$;


--
-- Name: ix_aid_date; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_aid_date' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX ix_aid_date ON public.nibrs_incident USING btree (agency_id, incident_date);
    END IF;
END $$;

--
-- Name: ix_incid; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_incid' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX ix_incid ON public.nibrs_incident USING btree (incident_id);
    END IF;
END $$;
--CREATE INDEX ix_incid ON public.nibrs_incident USING btree (incident_id);


--
-- Name: ix_ni_ai; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_ni_ai' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX ix_ni_ai ON public.nibrs_incident USING btree (agency_id);
    END IF;
END $$;
--CREATE INDEX ix_ni_ai ON public.nibrs_incident USING btree (agency_id);


--
-- Name: ix_nicei; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_nicei' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX ix_nicei ON public.nibrs_incident USING btree (cleared_except_id);
    END IF;
END $$;
--CREATE INDEX ix_nicei ON public.nibrs_incident USING btree (cleared_except_id);


--
-- Name: nibrs_incident_data_year_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'nibrs_incident_data_year_idx' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX nibrs_incident_data_year_idx ON public.nibrs_incident USING btree (data_year);
    END IF;
END $$;
--CREATE INDEX nibrs_incident_data_year_idx ON public.nibrs_incident USING btree (data_year);


--
-- Name: nibrs_incident_incident_id_idx; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'nibrs_incident_incident_id_idx' AND n.nspname = 'public'
    ) THEN
        CREATE UNIQUE INDEX nibrs_incident_incident_id_idx ON public.nibrs_incident USING btree (incident_id, data_year);
    END IF;
END $$;
--CREATE UNIQUE INDEX nibrs_incident_incident_id_idx ON public.nibrs_incident USING btree (incident_id, data_year);


--
-- Name: nibrs_incident_nibrs_month_id_idx; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'nibrs_incident_nibrs_month_id_idx' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX nibrs_incident_nibrs_month_id_idx ON public.nibrs_incident USING btree (nibrs_month_id);
    END IF;
END $$;
--CREATE INDEX nibrs_incident_nibrs_month_id_idx ON public.nibrs_incident USING btree (nibrs_month_id);


--
-- PostgreSQL database dump complete
--

