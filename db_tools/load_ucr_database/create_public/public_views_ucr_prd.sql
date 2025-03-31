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

--
-- Name: agencies_yearly; Type: VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'agencies_yearly'
    ) THEN
         CREATE VIEW public.agencies_yearly AS
         SELECT ref_agency_type.name AS agency_type_name,
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
            ref_agency_yearly.is_nibrs AS nibrs_participated,
            ref_agency_yearly.agency_status AS yearly_agency_status,
            ref_agency_yearly.population_group_id,
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
            ref_agency_yearly.is_suburban_area AS suburban_area_flag
            FROM ((((((((ucr_prd.ref_agency_yearly ref_agency_yearly
            LEFT JOIN ucr_prd.ref_agency USING (agency_id))
            LEFT JOIN ucr_prd.ref_state USING (state_id))
            LEFT JOIN ucr_prd.ref_division USING (division_id))
            LEFT JOIN ucr_prd.ref_region USING (region_id))
            LEFT JOIN ucr_prd.ref_agency_status USING (agency_id, data_year))
            LEFT JOIN ucr_prd.ref_submitting_agency USING (agency_id))
            LEFT JOIN ucr_prd.ref_agency_type USING (agency_type_id))
            LEFT JOIN ucr_prd.ref_agency_covered_by USING (agency_id, data_year))
         WHERE ((ref_agency_status.data_year IS NOT NULL) AND (ref_agency_yearly.is_nibrs IS TRUE));
      END IF;
END $$;



--
-- Name: nibrs_activity_type; Type: VIEW; Schema: public; Owner: -
--


DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_activity_type'
    ) THEN
         CREATE VIEW public.nibrs_activity_type AS
         SELECT (lkup_nibrs_activity.activity_code)::smallint AS activity_type_id,
            lkup_nibrs_activity.activity_code AS activity_type_code,
            lkup_nibrs_activity.name AS activity_type_name
           FROM ucr_prd.lkup_nibrs_activity;
    END IF;
END $$;


--
-- Name: nibrs_arrest_type; Type: VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_arrest_type'
    ) THEN
         CREATE VIEW public.nibrs_arrest_type AS
         SELECT lkup_nibrs_arrest_type.arrest_type_code,
            lkup_nibrs_arrest_type.name,
            lkup_nibrs_arrest_type.name AS arrest_type_name,
            lkup_nibrs_arrest_type.sort_order,
            lkup_nibrs_arrest_type.sort_order AS arrest_type_id
           FROM ucr_prd.lkup_nibrs_arrest_type;
    END IF;
END $$;

--
-- Name: nibrs_arrestee_weapon; Type: VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_arrestee_weapon'
    ) THEN
         CREATE VIEW public.nibrs_arrestee_weapon AS
         SELECT nibrs_arrestee_weapon.arrestee_id,
            nibrs_arrestee_weapon.weapon_code,
            nibrs_weapon_type.weapon_id,
            date_part('year'::text, nibrs_arrestee.arrest_date) AS data_year
           FROM ((ucr_prd.nibrs_arrestee_weapon
             JOIN public.nibrs_weapon_type USING (weapon_code))
             LEFT JOIN ucr_prd.nibrs_arrestee USING (arrestee_id));
    END IF;
END $$;

--
-- Name: nibrs_assignment_type; Type: VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_assignment_type'
    ) THEN
         CREATE VIEW public.nibrs_assignment_type AS
         SELECT lkup_assignment.sort_order AS assignment_type_id,
            lkup_assignment.assignment_code AS assignment_type_code,
            lkup_assignment.name AS assignment_type_name
           FROM ucr_prd.lkup_assignment;
    END IF;
END $$;


--
-- Name: nibrs_month; Type: VIEW; Schema: public; Owner: -
--
DO $$ begin
    if not exists (select from pg_views where schemaname = 'public' and viewname = 'nibrs_month') then
        create view public.nibrs_month as
        select form_month.data_year,
            form_month.form_month_id,
            form_month.form_month_id as nibrs_month_id,
            form_month.agency_id,
            form_month.data_month,
            form_month.data_month as month_num,
            form_month.month_included_in::smallint as month_included_in,
            form_month.form_code,
            form_month.is_zero_report,
                case
                    when (form_month.is_zero_report is true) then 'Z'::text
                    when (form_month.is_zero_report is false) then 'I'::text
                    else 'U'::text
                end as reported_status
           from ucr_prd.form_month;
    end if;
end $$;

--
-- Name: nibrs_relationship; Type: VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_relationship'
    ) THEN
         CREATE VIEW public.nibrs_relationship AS
         SELECT lkup_nibrs_relationship.relationship_code,
            lkup_nibrs_relationship.name AS relationship_name,
            lkup_nibrs_relationship.relationship_type_id,
            lkup_nibrs_relationship.sort_order AS relationship_id,
            lkup_nibrs_relationship.sort_order,
            lkup_nibrs_relationship.is_domestic
           FROM ucr_prd.lkup_nibrs_relationship;
    END IF;
END $$;


--
-- Name: nibrs_victim_circumstances; Type: VIEW; Schema: public; Owner: -
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_victim_circumstances'
    ) THEN
         CREATE VIEW public.nibrs_victim_circumstances AS
         SELECT nibrs_victim_circumstance.victim_id,
            nibrs_victim_circumstance.circumstance_code,
            nibrs_victim_circumstance.justifiable_force_code,
            nibrs_circumstances.circumstances_id,
            date_part('year'::text, nibrs_incident.incident_date) AS data_year,
            nibrs_justifiable_force.justifiable_force_id
           FROM ((((ucr_prd.nibrs_victim_circumstance
             LEFT JOIN public.nibrs_circumstances ON ((nibrs_victim_circumstance.circumstance_code = nibrs_circumstances.circumstances_code)))
             LEFT JOIN ucr_prd.nibrs_victim USING (victim_id))
             LEFT JOIN ucr_prd.nibrs_incident USING (incident_id))
             LEFT JOIN public.nibrs_justifiable_force USING (justifiable_force_code));
    END IF;
END $$;


--
-- Name: nibrs_victim_injury; Type: VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_victim_injury'
    ) THEN
         CREATE VIEW public.nibrs_victim_injury AS
         SELECT nibrs_victim_injury.victim_id,
            nibrs_injury.injury_id,
            date_part('year'::text, nibrs_incident.incident_date) AS data_year
           FROM (((ucr_prd.nibrs_victim_injury
             LEFT JOIN public.nibrs_injury USING (injury_code))
             LEFT JOIN ucr_prd.nibrs_victim USING (victim_id))
             LEFT JOIN ucr_prd.nibrs_incident USING (incident_id));
    END IF;
END $$;

--
-- Name: nibrs_victim_offender_rel; Type: VIEW; Schema: public; Owner: -
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_views WHERE schemaname = 'public' AND viewname = 'nibrs_victim_offender_rel'
    ) THEN
         CREATE VIEW public.nibrs_victim_offender_rel AS
         SELECT nibrs_victim_offender_relationship.victim_id,
            nibrs_victim_offender_relationship.offender_id,
            nibrs_victim_offender_relationship.relationship_code,
            lkup_nibrs_relationship.sort_order AS relationship_id
           FROM (ucr_prd.nibrs_victim_offender_relationship
             JOIN ucr_prd.lkup_nibrs_relationship USING (relationship_code));
    END IF;
END $$;
