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
-- Name: agencies; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'agencies'
    ) THEN
        CREATE MATERIALIZED VIEW public.agencies AS
        SELECT DISTINCT ref_agency_type.name AS agency_type_name,
            ref_agency.agency_type_id,
            ref_agency.pub_agency_unit,
            ref_agency.nibrs_ct_start_date,
            ref_agency.ori,
            ref_agency.agency_id,
            ref_agency.nibrs_off_eth_start_date,
            ref_agency.submitting_agency_id,
            ref_agency.ucr_agency_name,
            ref_agency.legacy_ori,
            ref_agency.nibrs_multi_bias_start_date,
            ref_agency.ncic_agency_name,
            ref_agency.nibrs_leoka_start_date,
            ref_agency.pub_agency_name,
            ref_agency.state_id,
            ref_agency.nibrs_start_date,
            ref_agency.judicial_district_code,
            ref_agency.tribe_id,
            ref_agency.department_id,
            ref_agency.legacy_notify_agency,
            ref_agency.city_id,
            ref_agency.special_mailing_group,
            ref_agency.population_family_id,
            ref_agency.campus_id,
            ref_agency.nibrs_leoka_except_flag,
            ref_agency.fid_code,
            ref_agency.field_office_id,
            ref_agency.tribal_district_id,
            ref_agency.added_date,
            ref_agency.special_mailing_address,
            ref_state.postal_abbr AS state_postal_abbr,
            ref_state.abbr AS state_abbr,
            ref_state.name AS state_name,
            ref_agency_status.agency_status,
            ref_agency_status.data_year,
            ref_submitting_agency.sai,
            ref_submitting_agency.nibrs_cert_date,
            ref_agency_yearly.is_direct_contributor AS direct_contributor_flag,
            ref_agency_yearly.is_nibrs,
            ref_agency_yearly.agency_status AS yearly_agency_status,
            ref_agency_yearly.population_group_id,
                CASE
                    WHEN (ref_agency_yearly.is_publishable IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_publishable IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END AS publishable_flag,
                CASE
                    WHEN (ref_agency_yearly.is_nibrs IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_nibrs IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END AS nibrs_participated,
            ref_population_group.code AS population_group_code,
            ref_population_group.description AS population_group_desc,
            ref_parent_population_group.code AS parent_pop_group_code,
            ref_parent_population_group.description AS parent_pop_group_desc,
                CASE
                    WHEN (ref_agency_yearly.is_covered IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_covered IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END AS covered_flag,
            ref_agency_yearly.population,
                CASE
                    WHEN (ref_agency_yearly.agency_status = 'D'::bpchar) THEN 'Y'::text
                    ELSE 'N'::text
                END AS dormant_flag,
                CASE
                    WHEN (ref_agency_yearly.agency_status = 'D'::bpchar) THEN ref_agency_yearly.data_year
                    ELSE NULL::smallint
                END AS dormant_year,
            ref_division.code AS division_code,
            ref_division.name AS division_name,
            ref_region.code AS region_code,
            ref_region.name AS region_name,
            ref_region.description AS region_desc,
                CASE
                    WHEN (ref_agency_yearly.is_suburban_area IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_suburban_area IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END AS suburban_area_flag,
            string_agg((ref_county.name)::text, '; '::text ORDER BY (ref_county.name)::text) AS county_name,
            string_agg((ref_metro_division.name)::text, '; '::text ORDER BY (ref_metro_division.name)::text) AS metro_div_name,
            string_agg((ref_msa.name)::text, '; '::text ORDER BY (ref_msa.name)::text) AS msa_name
        FROM ((((((((((((((ucr_prd.ref_agency_yearly ref_agency_yearly
            LEFT JOIN ucr_prd.ref_agency USING (agency_id))
            LEFT JOIN ucr_prd.ref_state USING (state_id))
            LEFT JOIN ucr_prd.ref_division USING (division_id))
            LEFT JOIN ucr_prd.ref_region USING (region_id))
            LEFT JOIN ucr_prd.ref_agency_status USING (agency_id, data_year))
            LEFT JOIN ucr_prd.ref_submitting_agency USING (agency_id))
            LEFT JOIN ucr_prd.ref_agency_type USING (agency_type_id))
            LEFT JOIN ucr_prd.ref_agency_covered_by USING (agency_id, data_year))
            LEFT JOIN ucr_prd.ref_population_group USING (population_group_id))
            LEFT JOIN ucr_prd.ref_parent_population_group USING (parent_pop_group_id))
            LEFT JOIN ucr_prd.ref_agency_county USING (agency_id, data_year))
            LEFT JOIN ucr_prd.ref_county USING (county_id))
            LEFT JOIN ucr_prd.ref_metro_division USING (metro_div_id))
            LEFT JOIN ucr_prd.ref_msa USING (msa_id))
        WHERE ((ref_agency_status.data_year IS NOT NULL) AND (ref_agency_yearly.is_nibrs IS TRUE))
        GROUP BY ref_agency_type.name, ref_agency.agency_type_id, ref_agency.pub_agency_unit, ref_agency.nibrs_ct_start_date, ref_agency.ori, ref_agency.agency_id, ref_agency.nibrs_off_eth_start_date, ref_agency.submitting_agency_id, ref_agency.ucr_agency_name, ref_agency.legacy_ori, ref_agency.nibrs_multi_bias_start_date, ref_agency.ncic_agency_name, ref_agency.nibrs_leoka_start_date, ref_agency.pub_agency_name, ref_agency.state_id, ref_agency.nibrs_start_date, ref_agency.judicial_district_code, ref_agency.tribe_id, ref_agency.department_id, ref_agency.legacy_notify_agency, ref_agency.city_id, ref_agency.special_mailing_group, ref_agency.population_family_id, ref_agency.campus_id, ref_agency.nibrs_leoka_except_flag, ref_agency.fid_code, ref_agency.field_office_id, ref_agency.tribal_district_id, ref_agency.added_date, ref_agency.special_mailing_address, ref_state.postal_abbr, ref_state.abbr, ref_state.name, ref_agency_status.agency_status, ref_agency_status.data_year, ref_submitting_agency.sai, ref_submitting_agency.nibrs_cert_date, ref_agency_yearly.is_direct_contributor, ref_agency_yearly.is_nibrs, ref_agency_yearly.agency_status, ref_agency_yearly.population_group_id,
                CASE
                    WHEN (ref_agency_yearly.is_publishable IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_publishable IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END,
                CASE
                    WHEN (ref_agency_yearly.is_nibrs IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_nibrs IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END, ref_population_group.code, ref_population_group.description, ref_parent_population_group.code, ref_parent_population_group.description,
                CASE
                    WHEN (ref_agency_yearly.is_covered IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_covered IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END, ref_agency_yearly.population,
                CASE
                    WHEN (ref_agency_yearly.agency_status = 'D'::bpchar) THEN 'Y'::text
                    ELSE 'N'::text
                END,
                CASE
                    WHEN (ref_agency_yearly.agency_status = 'D'::bpchar) THEN ref_agency_yearly.data_year
                    ELSE NULL::smallint
                END, ref_division.code, ref_division.name, ref_region.code, ref_region.name, ref_region.description,
                CASE
                    WHEN (ref_agency_yearly.is_suburban_area IS TRUE) THEN 'Y'::text
                    WHEN (ref_agency_yearly.is_suburban_area IS FALSE) THEN 'N'::text
                    ELSE ' '::text
                END
        WITH DATA;
    END IF;
END $$; 

--
-- Name: agency_county; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'agency_county'
    ) THEN
        CREATE MATERIALIZED VIEW public.agency_county AS
        SELECT ref_agency_county.agency_id,
            ref_agency_county.data_year,
            (lpad((ref_state.fips_code)::text, 2, '0'::text) || lpad((ref_county.fips_code)::text, 3, '0'::text)) AS fips_code,
            ref_agency_county.county_id,
            ref_agency_county.metro_div_id,
            ref_agency_county.is_core_city,
            ref_agency_county.population,
            ref_agency_county.legacy_county_code,
            ref_agency_county.legacy_msa_code,
            ref_agency_county.source_flag
        FROM (((ucr_prd.ref_agency_county
            JOIN ucr_prd.ref_county USING (county_id))
            LEFT JOIN ucr_prd.ref_agency_yearly USING (agency_id, data_year))
            LEFT JOIN ucr_prd.ref_state USING (state_id))
        WHERE (ref_agency_yearly.is_nibrs IS TRUE)
        WITH DATA;
    END IF;
END $$;


--
-- Name: county; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'county'
    ) THEN
        CREATE MATERIALIZED VIEW public.county AS
        SELECT ref_county.county_id,
            ref_county.state_id,
            lpad((ref_county.fips_code)::text, 3, '0'::text) AS county_fips_code,
            lpad((ref_state.fips_code)::text, 2, '0'::text) AS state_fips_code,
            ref_county.name,
            ref_county.name AS county_name,
            ref_state.name AS state_name,
            ref_county.ansi_code,
            (lpad((ref_state.fips_code)::text, 2, '0'::text) || lpad((ref_county.fips_code)::text, 3, '0'::text)) AS fips_code,
            ref_county.legacy_code,
            ref_county.comments
        FROM (ucr_prd.ref_county
            JOIN ucr_prd.ref_state USING (state_id))
        WITH DATA;
    END IF;
END $$;


--
-- Name: nibrs_arrestee; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_arrestee'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_arrestee AS
        SELECT nibrs_arrestee.arrestee_id,
            nibrs_arrestee.incident_id,
            nibrs_arrestee.sequence_number,
            nibrs_arrestee.sequence_number AS arrestee_seq_num,
            nibrs_arrestee.arrest_number,
            nibrs_arrestee.arrest_date,
            ni.data_year AS incident_data_year,
            date_part('year'::text, nibrs_arrestee.arrest_date) AS arrestee_data_year,
            nibrs_arrestee.arrest_type_code,
            nibrs_arrestee.multiple_indicator_code,
            nibrs_arrestee.multiple_indicator_code AS multiple_indicator,
            nibrs_arrestee.offense_code,
            nibrs_offense_type.offense_type_id,
                CASE
                    WHEN (nibrs_arrestee.age_code = ANY (ARRAY['NN'::bpchar, 'NB'::bpchar, 'BB'::bpchar, '00'::bpchar, 'AG'::bpchar, '99'::bpchar])) THEN nibrs_age.age_id
                    WHEN (nibrs_arrestee.age_code = 'NS'::bpchar) THEN NULL::smallint
                    ELSE (5)::smallint
                END AS age_id,
            nibrs_arrestee.age_code,
                CASE
                    WHEN ((nibrs_arrestee.age_code = 'NN'::bpchar) OR (nibrs_arrestee.age_code = 'NB'::bpchar) OR (nibrs_arrestee.age_code = 'BB'::bpchar) OR (nibrs_arrestee.age_code = '00'::bpchar) OR (nibrs_arrestee.age_code = 'AG'::bpchar) OR (nibrs_arrestee.age_code = '99'::bpchar) OR (nibrs_arrestee.age_code = 'NS'::bpchar)) THEN NULL::bpchar
                    ELSE nibrs_arrestee.age_code
                END AS age_num,
            nibrs_arrestee.age_code_range_low,
            nibrs_arrestee.age_code_range_low AS age_range_low_num,
            nibrs_arrestee.age_code_range_high,
            nibrs_arrestee.age_code_range_high AS age_range_high_num,
            nibrs_arrestee.sex_code,
            ref_race.race_id,
            nibrs_arrestee.race_code,
            nibrs_ethnicity.ethnicity_id,
            nibrs_arrestee.ethnicity_code,
            nibrs_arrestee.resident_status_code,
                CASE
                    WHEN (nibrs_arrestee.resident_status_code IS NULL) THEN ' '::bpchar
                    ELSE nibrs_arrestee.resident_status_code
                END AS resident_code,
                CASE
                    WHEN (nibrs_arrestee.under_18_disposition_code IS NULL) THEN ' '::bpchar
                    ELSE nibrs_arrestee.under_18_disposition_code
                END AS under_18_disposition_code,
            nibrs_arrest_type.arrest_type_id,
            nibrs_arrest_type.name AS arrest_type_name
        FROM (((((((ucr_prd.nibrs_arrestee
            LEFT JOIN public.nibrs_incident ni USING (incident_id)
            LEFT JOIN public.nibrs_arrest_type USING (arrest_type_code))
            LEFT JOIN public.nibrs_offense_type USING (offense_code))
            LEFT JOIN public.nibrs_age USING (age_code))
            LEFT JOIN ucr_prd.lkup_sex USING (sex_code))
            LEFT JOIN public.ref_race USING (race_code))
            LEFT JOIN public.nibrs_ethnicity USING (ethnicity_code))
            LEFT JOIN ucr_prd.lkup_nibrs_resident_status USING (resident_status_code))
        WITH DATA;
    END IF;
END $$;


DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_bias_motivation'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_bias_motivation AS
        SELECT nibrs_bias_motivation.offense_id,
            nibrs_bias_motivation.bias_code,
            nibrs_bias_list.bias_id,
            nibrs_offense.data_year
        FROM ((ucr_prd.nibrs_bias_motivation
            JOIN public.nibrs_bias_list USING (bias_code))
            JOIN public.nibrs_offense USING (offense_id))
        WITH DATA;

        ALTER TABLE public.nibrs_bias_motivation OWNER TO postgres;
    END IF;
END $$;

--
-- Name: nibrs_offender; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_offender'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_offender AS
        SELECT nibrs_offender.offender_id,
            nibrs_offender.incident_id,
            (nibrs_incident.data_year)::integer AS data_year,
            (nibrs_offender.sequence_number)::smallint AS offender_seq_num,
                CASE
                    WHEN (nibrs_offender.age_code = ANY (ARRAY['NN'::bpchar, 'NB'::bpchar, 'BB'::bpchar, '00'::bpchar, 'AG'::bpchar, '99'::bpchar])) THEN nibrs_age.age_id
                    WHEN (nibrs_offender.age_code = 'NS'::bpchar) THEN NULL::smallint
                    ELSE (5)::smallint
                END AS age_id,
            nibrs_age.age_name,
                CASE
                    WHEN (nibrs_offender.age_code = ANY (ARRAY['NN'::bpchar, 'NB'::bpchar, 'BB'::bpchar, '00'::bpchar, 'AG'::bpchar, '99'::bpchar, 'NS'::bpchar])) THEN NULL::bpchar
                    ELSE nibrs_offender.age_code
                END AS age_num,
            nibrs_offender.age_code,
            nibrs_offender.age_code_range_low,
            nibrs_offender.age_code_range_high,
            nibrs_offender.age_code_range_low AS age_range_low_num,
            nibrs_offender.age_code_range_high AS age_range_high_num,
                CASE
                    WHEN (nibrs_offender.sex_code = 'X'::bpchar) THEN ' '::bpchar
                    ELSE nibrs_offender.sex_code
                END AS sex_code,
            race_code,
            nibrs_race.race_id,
            nibrs_race.race_desc,
            nibrs_offender.ethnicity_code,
            nibrs_ethnicity.ethnicity_id,
            nibrs_ethnicity.ethnicity_name
        FROM ((((ucr_prd.nibrs_offender nibrs_offender
            LEFT JOIN public.nibrs_age nibrs_age USING (age_code))
            LEFT JOIN public.nibrs_incident nibrs_incident USING (incident_id))
            LEFT JOIN public.ref_race nibrs_race USING (race_code))
            LEFT JOIN public.nibrs_ethnicity nibrs_ethnicity USING (ethnicity_code))
        WITH DATA;
    END IF;
END $$;


--
-- Name: nibrs_property; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_property'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_property AS
        SELECT nibrs_property.property_id,
            nibrs_property.incident_id,
            nibrs_property.prop_loss_code,
            nibrs_property.prop_loss_code AS prop_loss_id,
            nibrs_property.stolen_count,
            nibrs_property.recovered_count,
            nibrs_incident.data_year
        FROM (ucr_prd.nibrs_property
            JOIN public.nibrs_incident USING (incident_id))
        WITH DATA;
    END IF;
END $$;

--
-- Name: nibrs_property_desc; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_property_desc'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_property_desc AS
        SELECT nibrs_property_description.property_id,
            nibrs_property_description.prop_desc_code,
            (nibrs_prop_desc_type.prop_desc_id)::integer AS prop_desc_id,
            (nibrs_prop_desc_type.prop_desc_id)::integer AS nibrs_prop_desc_id,
            nibrs_prop_desc_type.prop_desc_name,
            nibrs_property_description.property_value,
            nibrs_property_description.date_recovered,
            nibrs_incident.data_year
        FROM (((ucr_prd.nibrs_property_description
            LEFT JOIN ucr_prd.nibrs_property USING (property_id))
            LEFT JOIN public.nibrs_prop_desc_type USING (prop_desc_code))
            LEFT JOIN public.nibrs_incident USING (incident_id))
        WITH DATA;
    END IF;
END $$;



--
-- Name: nibrs_suspected_drug; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_suspected_drug'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_suspected_drug AS
        SELECT nibrs_suspected_drug.suspected_drug_id AS nibrs_suspected_drug_id,
            nibrs_suspected_drug.drug_code,
            nibrs_suspected_drug.drug_measure_code,
            nibrs_suspected_drug.est_drug_qty,
            nibrs_suspected_drug.property_id,
            nibrs_suspected_drug_type.suspected_drug_type_id,
            nibrs_drug_measure_type.drug_measure_type_id,
            date_part('year'::text, nibrs_incident.incident_date) AS data_year
        FROM ((((ucr_prd.nibrs_suspected_drug
            LEFT JOIN public.nibrs_suspected_drug_type ON ((nibrs_suspected_drug.drug_code = nibrs_suspected_drug_type.suspected_drug_code)))
            LEFT JOIN public.nibrs_drug_measure_type USING (drug_measure_code))
            LEFT JOIN ucr_prd.nibrs_property USING (property_id))
            LEFT JOIN ucr_prd.nibrs_incident USING (incident_id))
        WITH DATA;
    END IF;
END $$;


--
-- Name: nibrs_victim; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_victim'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_victim AS
        SELECT nibrs_victim.victim_id,
            nibrs_victim.incident_id,
            nibrs_victim.sequence_number,
            nibrs_victim.sequence_number AS victim_seq_num,
            nibrs_victim.victim_type_code,
            nibrs_victim_type.victim_type_id,
            nibrs_victim.age_code,
            nibrs_victim.age_code_range_low,
            nibrs_victim.age_code_range_high,
                CASE
                    WHEN (nibrs_victim.sex_code = 'X'::bpchar) THEN ' '::bpchar
                    ELSE nibrs_victim.sex_code
                END AS sex_code,
            nibrs_victim.race_code,
            nibrs_victim.ethnicity_code,
                CASE
                    WHEN (nibrs_victim.resident_status_code = 'None'::bpchar) THEN ' '::bpchar
                    WHEN (nibrs_victim.resident_status_code = '-1'::bpchar) THEN ' '::bpchar
                    WHEN (nibrs_victim.resident_status_code IS NULL) THEN ' '::bpchar
                    ELSE nibrs_victim.resident_status_code
                END AS resident_status_code,
            nibrs_victim.activity_code,
            nibrs_victim.assignment_code,
            nibrs_victim.outside_agency_id,
            nibrs_victim_type.victim_type_name,
                CASE
                    WHEN (nibrs_victim.age_code = ANY (ARRAY['NN'::bpchar, 'NB'::bpchar, 'BB'::bpchar, '00'::bpchar, 'AG'::bpchar, '99'::bpchar])) THEN nibrs_age.age_id
                    WHEN (nibrs_victim.age_code = 'NS'::bpchar) THEN NULL::smallint
                    ELSE (5)::smallint
                END AS age_id,
            lkup_age.name AS age_name,
                CASE
                    WHEN (nibrs_victim.age_code = ANY (ARRAY['NN'::bpchar, 'NB'::bpchar, 'BB'::bpchar, '00'::bpchar, 'NS'::bpchar, '99'::bpchar])) THEN NULL::bpchar
                    ELSE nibrs_victim.age_code
                END AS age_num,
            nibrs_ethnicity.ethnicity_id,
            ref_race.race_id,
            nibrs_incident.data_year,
            lkup_assignment.sort_order AS assignment_type_id,
            lkup_assignment.name AS assignment_type_name,
            lkup_assignment.assignment_code AS assignment_type_code,
            lkup_nibrs_activity.sort_order AS activity_type_id,
            lkup_nibrs_activity.activity_code AS activity_type_code,
            lkup_nibrs_activity.name AS activity_type_name,
            nibrs_incident.agency_id,
            nibrs_victim.age_code_range_low AS age_range_low_num,
            nibrs_victim.age_code_range_high AS age_range_high_num
        FROM ((((((((ucr_prd.nibrs_victim
            LEFT JOIN public.nibrs_victim_type USING (victim_type_code))
            LEFT JOIN public.nibrs_age USING (age_code))
            LEFT JOIN ucr_prd.lkup_age USING (age_code))
            LEFT JOIN public.ref_race USING (race_code))
            LEFT JOIN public.nibrs_ethnicity USING (ethnicity_code))
            LEFT JOIN ucr_prd.lkup_assignment USING (assignment_code))
            LEFT JOIN ucr_prd.lkup_nibrs_activity USING (activity_code))
            JOIN public.nibrs_incident USING (incident_id))
        WITH DATA;
    END IF;
END $$;


--
-- Name: nibrs_victim_offense; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_matviews WHERE schemaname = 'public' AND matviewname = 'nibrs_victim_offense'
    ) THEN
        CREATE MATERIALIZED VIEW public.nibrs_victim_offense AS
        SELECT nibrs_victim_offense.victim_id,
            nibrs_victim_offense.offense_id,
            nibrs_offense.data_year
        FROM (ucr_prd.nibrs_victim_offense
            LEFT JOIN public.nibrs_offense USING (offense_id))
        WITH DATA;
    END IF;
END $$;


--
-- Name: agencies_agency_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'agencies_agency_id_idx'
    ) THEN
        CREATE UNIQUE INDEX agencies_agency_id_idx ON public.agencies USING btree (agency_id, data_year);
    END IF;
END $$;

--
-- Name: agencies_state_name_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'agencies_state_name_idx'
    ) THEN
        CREATE INDEX agencies_state_name_idx ON public.agencies USING btree (state_name, data_year);
    END IF;
END $$;

--
-- Name: agency_county_agency_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'agency_county_agency_id_idx'
    ) THEN
        CREATE INDEX agency_county_agency_id_idx ON public.agency_county USING btree (agency_id, data_year, county_id);
    END IF;
END $$;

--
-- Name: ix_07; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_07'
    ) THEN
        CREATE INDEX ix_07 ON public.nibrs_victim USING btree (data_year, victim_id, incident_id);
    END IF;
END $$;

--
-- Name: ix_08; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_08'
    ) THEN
        CREATE INDEX ix_08 ON public.nibrs_victim USING btree (victim_type_id);
    END IF;
END $$;


--
-- Name: ix_14; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_14'
    ) THEN
        CREATE INDEX ix_14 ON public.nibrs_victim USING btree (data_year, incident_id);
    END IF;
END $$;


--
-- Name: ix_15; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_15'
    ) THEN
        CREATE INDEX ix_15 ON public.nibrs_offender USING btree (data_year, incident_id, offender_id);
    END IF;
END $$;


--
-- Name: ix_20; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_20'
    ) THEN
        CREATE INDEX ix_20 ON public.nibrs_victim USING btree (assignment_type_id);
    END IF;
END $$;


--
-- Name: ix_22; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_22'
    ) THEN
        CREATE INDEX ix_22 ON public.nibrs_victim USING btree (race_id);
END IF;
END $$; 

--
-- Name: ix_24; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_24'
    ) THEN
        CREATE INDEX ix_24 ON public.nibrs_victim USING btree (ethnicity_id);
END IF;
END $$; 

--
-- Name: ix_agency_state_abbr; Type: INDEX; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_agency_state_abbr'
    ) THEN
        CREATE INDEX ix_agency_state_abbr ON public.agencies USING btree (state_abbr);
    END IF;
END $$;

--
-- Name: ix_agid; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_agid'
    ) THEN
        CREATE INDEX ix_agid ON public.agency_county USING btree (agency_id, data_year);
    END IF;
END $$;


--
-- Name: ix_agid2; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_agid2'
    ) THEN
        CREATE INDEX ix_agid2 ON public.agency_county USING btree (agency_id, data_year);
    END IF;
END $$;


--
-- Name: ix_cfips; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_cfips'
    ) THEN
        CREATE INDEX ix_cfips ON public.agency_county USING btree (fips_code);
    END IF;
END $$;


--
-- Name: ix_cfips2; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_cfips2'
    ) THEN
        CREATE INDEX ix_cfips2 ON public.county USING btree (fips_code);
    END IF;
END $$;


--
-- Name: ix_cid; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_cid'
    ) THEN
        CREATE INDEX ix_cid ON public.agency_county USING btree (county_id);
    END IF;
END $$;


--
-- Name: ix_eth1; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_eth1'
    ) THEN
        CREATE INDEX ix_eth1 ON public.nibrs_arrestee USING btree (ethnicity_id);
    END IF;
END $$;


--
-- Name: ix_nat2; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_nat2'
    ) THEN
        CREATE INDEX ix_nat2 ON public.nibrs_arrestee USING btree (arrest_type_id);
    END IF;
END $$;


--
-- Name: ix_race2; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_race2'
    ) THEN
        CREATE INDEX ix_race2 ON public.nibrs_arrestee USING btree (race_id);
END IF;
END $$;

--
-- Name: ix_suspected_drug_id; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_suspected_drug_id'
    ) THEN
        CREATE INDEX ix_suspected_drug_id ON public.nibrs_suspected_drug USING btree (nibrs_suspected_drug_id);
    END IF;
END $$;


--
-- Name: ix_suspected_drug_type_id; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_suspected_drug_type_id'
    ) THEN
        CREATE INDEX ix_suspected_drug_type_id ON public.nibrs_suspected_drug USING btree (suspected_drug_type_id);
    END IF;
END $$;


--
-- Name: nibrs_arrestee_arrestee_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_arrestee_arrestee_id_idx'
    ) THEN
        CREATE INDEX nibrs_arrestee_arrestee_id_idx ON public.nibrs_arrestee USING btree (arrestee_id);
    END IF;
END $$;


--
-- Name: nibrs_arrestee_incident_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_arrestee_incident_id_idx'
    ) THEN
        CREATE INDEX nibrs_arrestee_incident_id_idx ON public.nibrs_arrestee USING btree (incident_id);
    END IF;
END $$;


--
-- Name: nibrs_offender_incident_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_offender_incident_id_idx'
    ) THEN
        CREATE INDEX nibrs_offender_incident_id_idx ON public.nibrs_offender USING btree (incident_id);
    END IF;
END $$;


--
-- Name: nibrs_offender_incident_id_offender_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_offender_incident_id_offender_id_idx'
    ) THEN
        CREATE UNIQUE INDEX nibrs_offender_incident_id_offender_id_idx ON public.nibrs_offender USING btree (incident_id, offender_id);
    END IF;
END $$;


--
-- Name: nibrs_offender_offender_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_offender_offender_id_idx'
    ) THEN
        CREATE UNIQUE INDEX nibrs_offender_offender_id_idx ON public.nibrs_offender USING btree (offender_id);
    END IF;
END $$;


--
-- Name: nibrs_property_desc_property_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_property_desc_property_id_idx'
    ) THEN
        CREATE UNIQUE INDEX nibrs_property_desc_property_id_idx ON public.nibrs_property_desc USING btree (property_id, nibrs_prop_desc_id);
    END IF;
END $$;
--
-- Name: nibrs_property_incident_id_property_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_property_incident_id_property_id_idx'
    ) THEN
        CREATE UNIQUE INDEX nibrs_property_incident_id_property_id_idx ON public.nibrs_property USING btree (incident_id, property_id, data_year) INCLUDE (prop_loss_code, prop_loss_id, stolen_count, recovered_count);
    END IF;
END $$;


--
-- Name: nibrs_victim_incident_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_victim_incident_id_idx'
    ) THEN
        CREATE INDEX nibrs_victim_incident_id_idx ON public.nibrs_victim USING btree (incident_id);
    END IF;
END $$;


--
-- Name: nibrs_victim_offense_offense_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_victim_offense_offense_id_idx'
    ) THEN
        CREATE INDEX nibrs_victim_offense_offense_id_idx ON public.nibrs_victim_offense USING btree (offense_id);
    END IF;
END $$;


--
-- Name: nibrs_victim_offense_offense_id_victim_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_victim_offense_offense_id_victim_id_idx'
    ) THEN
        CREATE UNIQUE INDEX nibrs_victim_offense_offense_id_victim_id_idx ON public.nibrs_victim_offense USING btree (offense_id, victim_id);
    END IF;
END $$;


--
-- Name: nibrs_victim_victim_id_idx; Type: INDEX; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_victim_victim_id_idx'
    ) THEN
        CREATE UNIQUE INDEX nibrs_victim_victim_id_idx ON public.nibrs_victim USING btree (victim_id);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_victim_offense_data_year_idx'
    ) THEN
        CREATE INDEX nibrs_victim_offense_data_year_idx ON public.nibrs_victim_offense USING btree (data_year);
    END IF;
END $$;
--CREATE INDEX nibrs_victim_offense_data_year_idx ON public.nibrs_victim_offense USING btree (data_year)

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'nibrs_bias_motivation_data_year_idx'
    ) THEN
        CREATE INDEX nibrs_bias_motivation_data_year_idx ON public.nibrs_bias_motivation USING btree (data_year, offense_id);
    END IF;
END $$;
--CREATE INDEX nibrs_bias_motivation_data_year_idx ON public.nibrs_bias_motivation USING btree (data_year, offense_id)

-- Grant permissions to readaccess group
GRANT USAGE ON SCHEMA public TO readaccess;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess;