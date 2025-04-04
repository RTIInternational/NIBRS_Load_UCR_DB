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
-- Name: nibrs_offense; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_offense'
    ) THEN
      CREATE MATERIALIZED VIEW public.nibrs_offense AS
      SELECT nibrs_offense.offense_id,
          nibrs_offense.incident_id,
          nibrs_offense.attempt_complete_code,
          nibrs_offense.attempt_complete_code AS attempt_complete_flag,
          nibrs_offense.location_code,
          nibrs_offense.num_premises_entered,
          nibrs_offense.method_of_entry_code,
          nibrs_incident.data_year,
              CASE
                  WHEN (nibrs_offense.method_of_entry_code IS NULL) THEN ' '::bpchar
                  ELSE nibrs_offense.method_of_entry_code
              END AS method_entry_code,
          nibrs_offense_type.offense_type_id,
          nibrs_offense_type.offense_code,
          nibrs_offense_type.offense_name,
          nibrs_offense_type.crime_against,
          nibrs_offense_type.ct_flag,
          nibrs_offense_type.hc_flag,
          nibrs_offense_type.hc_code,
          nibrs_offense_type.offense_category_name,
          nibrs_offense_type.offense_group,
          nibrs_offense_type.count_method,
          nibrs_offense_type.offense_hier_level,
          nibrs_offense_type.sort_order,
          nibrs_offense_type.offense_label,
          nibrs_offense_type.hc_eff_date,
          nibrs_offense_type.ct_eff_date,
          nibrs_offense_type.crime_against_sort_order,
          nibrs_offense_type.hc_offense_name,
          nibrs_offense_type.hc_offense_name_sort_order,
          nibrs_offense_type.offense_category_sort_order,
          nibrs_location_type.location_id,
          nibrs_location_type.location_name
        FROM (((ucr_prd.nibrs_offense
          LEFT JOIN public.nibrs_offense_type USING (offense_code))
          LEFT JOIN public.nibrs_incident USING (incident_id))
          LEFT JOIN public.nibrs_location_type USING (location_code))
        WITH DATA;
    END IF;
END $$;



--
-- Name: ix_01; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_01' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX ix_01 ON public.nibrs_offense USING btree (data_year, incident_id);
    END IF;
END $$;
--CREATE INDEX ix_01 ON public.nibrs_offense USING btree (data_year, incident_id);


--
-- Name: ix_lid2; Type: INDEX; Schema: public; Owner: -
--
DO $$ begin
    if not exists (select 1 from pg_class c join pg_namespace n on n.oid = c.relnamespace where c.relname = 'ix_lid2' and n.nspname = 'public') then
        create index ix_lid2 on public.nibrs_offense using btree (location_id);
    end if;
end $$;
--CREATE INDEX ix_lid2 ON public.nibrs_offense USING btree (location_id);


--
-- Name: nibrs_offense_incident_id_idx; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'nibrs_offense_incident_id_idx' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX nibrs_offense_incident_id_idx ON public.nibrs_offense USING btree (incident_id);
    END IF;
END $$;
--CREATE INDEX nibrs_offense_incident_id_idx ON public.nibrs_offense USING btree (incident_id);


--
-- Name: nibrs_offense_location_id_idx; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'nibrs_offense_location_id_idx' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX nibrs_offense_location_id_idx ON public.nibrs_offense USING btree (location_id);
    END IF;
END $$;
--CREATE INDEX nibrs_offense_location_id_idx ON public.nibrs_offense USING btree (location_id);


--
-- Name: nibrs_offense_offense_id_idx; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'nibrs_offense_offense_id_idx' AND n.nspname = 'public'
    ) THEN
        CREATE UNIQUE INDEX nibrs_offense_offense_id_idx ON public.nibrs_offense USING btree (offense_id);
    END IF;
END $$;
--CREATE UNIQUE INDEX nibrs_offense_offense_id_idx ON public.nibrs_offense USING btree (offense_id);


--
-- Name: nibrs_offense_offense_type_id_idx; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'nibrs_offense_offense_type_id_idx' AND n.nspname = 'public'
    ) THEN
        CREATE INDEX nibrs_offense_offense_type_id_idx ON public.nibrs_offense USING btree (offense_type_id);
    END IF;
END $$;
--CREATE INDEX nibrs_offense_offense_type_id_idx ON public.nibrs_offense USING btree (offense_type_id);


--
-- PostgreSQL database dump complete
--


--
-- Name: nibrs_suspect_using; Type: VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_suspect_using'
    ) THEN
      CREATE VIEW public.nibrs_suspect_using AS
      SELECT nibrs_suspect_using.offense_id,
          lkup_nibrs_using_list.sort_order AS suspect_using_id,
          nibrs_offense.data_year
        FROM ((ucr_prd.nibrs_suspect_using
          LEFT JOIN ucr_prd.lkup_nibrs_using_list USING (using_code))
          LEFT JOIN public.nibrs_offense USING (offense_id));
    END IF;
END $$;

--
-- Name: nibrs_weapon; Type: VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_weapon'
    ) THEN
      CREATE VIEW public.nibrs_weapon AS
      SELECT nibrs_offense_weapon.offense_id,
          nibrs_weapon_type.weapon_id,
          nibrs_weapon_type.shr_flag,
          nibrs_weapon_type.offense_flag,
          nibrs_weapon_type.arrestee_flag,
          nibrs_weapon_type.weap_hier_level,
          nibrs_weapon_type.sort_order,
          nibrs_weapon_type.shr_hier_level,
          nibrs_weapon_type.weapon_category_id,
          nibrs_weapon_type.weapon_id AS nibrs_weapon_id,
          nibrs_offense.data_year
        FROM ((ucr_prd.nibrs_offense_weapon
          JOIN public.nibrs_weapon_type USING (weapon_code))
          JOIN public.nibrs_offense USING (offense_id));
    END IF;
END $$;

--
-- Name: nibrs_criminal_act; Type: VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_criminal_act'
    ) THEN
      CREATE VIEW public.nibrs_criminal_act AS
      SELECT nibrs_criminal_activity.offense_id,
          nibrs_criminal_activity.criminal_activity_code,
          nibrs_criminal_act_type.criminal_act_id,
          nibrs_criminal_act_type.criminal_act_code,
          nibrs_criminal_act_type.criminal_act_name,
          nibrs_criminal_act_type.criminal_act_desc,
          nibrs_criminal_act_type.sort_order,
          nibrs_offense.data_year
        FROM ((public.nibrs_criminal_act_type
          RIGHT JOIN ucr_prd.nibrs_criminal_activity ON ((nibrs_criminal_act_type.criminal_act_code = nibrs_criminal_activity.criminal_activity_code)))
          JOIN public.nibrs_offense USING (offense_id));
    END IF;
END $$;
