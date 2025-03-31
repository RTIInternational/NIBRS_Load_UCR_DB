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
-- Name: nibrs_age; Type: TABLE; Schema: public; Owner: postgres
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_age'
    ) THEN
        CREATE TABLE public.nibrs_age (
            age_id smallint NOT NULL,
            age_code character(2),
            age_name character varying(100)
        );
        ALTER TABLE public.nibrs_age OWNER TO postgres;
        ALTER TABLE public.nibrs_age
            ADD CONSTRAINT age_id_unique UNIQUE (age_id);
    END IF;
END $$;


--
-- Name: nibrs_ethnicity; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_ethnicity'
    ) THEN
        CREATE TABLE public.nibrs_ethnicity (
            ethnicity_id smallint NOT NULL,
            ethnicity_code character(1),
            ethnicity_name character varying(100),
            CONSTRAINT ethnicity_pkey PRIMARY KEY (ethnicity_id)
        );
        ALTER TABLE public.nibrs_ethnicity OWNER TO postgres;
    END IF;
END $$;
--
-- Name: nibrs_offense_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_offense_type'
    ) THEN
        CREATE TABLE public.nibrs_offense_type (
            offense_type_id smallint NOT NULL,
            offense_code character varying(5),
            offense_name character varying(100),
            crime_against character varying(100),
            ct_flag character(1),
            hc_flag character(1),
            hc_code character varying(5),
            offense_category_name character varying(100),
            offense_group character(5),
            count_method text,
            offense_hier_level text,
            sort_order text,
            offense_label text,
            hc_eff_date text,
            ct_eff_date text,
            crime_against_sort_order text,
            hc_offense_name text,
            hc_offense_name_sort_order text,
            offense_category_sort_order text,
            CONSTRAINT offense_type_pkey PRIMARY KEY (offense_type_id)
        );
        ALTER TABLE public.nibrs_offense_type OWNER TO postgres;
    END IF;
END $$;


--
-- Name: ref_race; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'ref_race'
    ) THEN
        CREATE TABLE public.ref_race (
            race_id smallint NOT NULL,
            race_code text,
            race_desc text,
            sort_order text,
            start_year text,
            end_year text,
            notes text,
            CONSTRAINT race_pkey PRIMARY KEY (race_id)
        );
        ALTER TABLE public.ref_race OWNER TO postgres;
    END IF;
END $$;

--
-- Name: nibrs_weapon_type; Type: TABLE; Schema: public; Owner: postgres
--
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_weapon_type'
    ) THEN
        CREATE TABLE public.nibrs_weapon_type (
            weapon_id smallint NOT NULL,
            weapon_code character varying(3),
            weapon_name character varying(100),
            shr_flag character(1),
            offense_flag character(1),
            arrestee_flag character(1),
            weap_hier_level smallint,
            sort_order smallint,
            shr_hier_level smallint,
            weapon_category_id smallint,
            CONSTRAINT weapon_pkey PRIMARY KEY (weapon_id)
        );


        ALTER TABLE public.nibrs_weapon_type OWNER TO postgres;
END IF;
END $$;
--
-- Name: nibrs_bias_list; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_bias_list'
    ) THEN
        CREATE TABLE public.nibrs_bias_list (
            bias_id smallint NOT NULL,
            bias_code character(2),
            bias_name_new character varying(100),
            bias_name character varying(100),
            bias_desc character varying(100),
            sort_order smallint,
            bias_category_sort_order smallint,
            bias_category_id smallint,
            CONSTRAINT bias_pkey PRIMARY KEY (bias_id)
        );
        ALTER TABLE public.nibrs_bias_list OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_cleared_except; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_cleared_except'
    ) THEN
        CREATE TABLE public.nibrs_cleared_except (
            cleared_except_id smallint NOT NULL,
            cleared_except_code character(1),
            cleared_except_name character varying(100),
            cleared_except_desc character varying(300),
            sort_order smallint,
            CONSTRAINT cleared_except_pkey PRIMARY KEY (cleared_except_id)
        );
        ALTER TABLE public.nibrs_cleared_except OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_location_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_location_type'
    ) THEN
        CREATE TABLE public.nibrs_location_type (
            location_id bigint NOT NULL,
            location_code character(2),
            location_name character varying(100),
            sort_order smallint,
            CONSTRAINT location_pkey PRIMARY KEY (location_id)
        );
        ALTER TABLE public.nibrs_location_type OWNER TO postgres;
    END IF;
END $$;


ALTER TABLE public.nibrs_location_type OWNER TO postgres;

--
-- Name: nibrs_circumstances; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_circumstances'
    ) THEN
        CREATE TABLE public.nibrs_circumstances (
            circumstances_id smallint NOT NULL,
            circumstances_type character(1),
            circumstances_code smallint,
            circumstances_name character varying(100),
            CONSTRAINT circumstances_pkey PRIMARY KEY (circumstances_id)    
        );
        ALTER TABLE public.nibrs_circumstances OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_criminal_act_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_criminal_act_type'
    ) THEN
        CREATE TABLE public.nibrs_criminal_act_type (
            criminal_act_id smallint NOT NULL,
            criminal_act_code character(1),
            criminal_act_name character varying(100),
            criminal_act_desc character varying(300),
            sort_order smallint,
            CONSTRAINT criminal_act_pkey PRIMARY KEY (criminal_act_id)
        );
        ALTER TABLE public.nibrs_criminal_act_type OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_drug_measure_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_drug_measure_type'
    ) THEN
        CREATE TABLE public.nibrs_drug_measure_type (
            drug_measure_type_id smallint NOT NULL,
            drug_measure_code character(2),
            drug_measure_name character varying(100),
            CONSTRAINT drug_measure_type_pkey PRIMARY KEY (drug_measure_type_id)
        );
        ALTER TABLE public.nibrs_drug_measure_type OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_injury; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_injury'
    ) THEN
        CREATE TABLE public.nibrs_injury (
            injury_id smallint NOT NULL,
            injury_code character(1),
            injury_name character varying(100),
            CONSTRAINT injury_pkey PRIMARY KEY (injury_id)
        );
        ALTER TABLE public.nibrs_injury OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_justifiable_force; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_justifiable_force'
    ) THEN
        CREATE TABLE public.nibrs_justifiable_force (
            justifiable_force_id smallint NOT NULL,
            justifiable_force_code character(1),
            justifiable_force_name character varying(100),
            CONSTRAINT justifiable_force_pkey PRIMARY KEY (justifiable_force_id)
        
        );
        ALTER TABLE public.nibrs_justifiable_force OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_prop_desc_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_prop_desc_type'
    ) THEN
        CREATE TABLE public.nibrs_prop_desc_type (
            prop_desc_id smallint NOT NULL,
            prop_desc_code character(2),
            prop_desc_name character varying(100),
            CONSTRAINT prop_desc_pkey PRIMARY KEY (prop_desc_id)
        );
        ALTER TABLE public.nibrs_prop_desc_type OWNER TO postgres;
    END IF;
END $$;


ALTER TABLE public.nibrs_prop_desc_type OWNER TO postgres;

--
-- Name: nibrs_prop_loss_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_prop_loss_type'
    ) THEN
        CREATE TABLE public.nibrs_prop_loss_type (
            prop_loss_id smallint NOT NULL,
            prop_loss_name character varying(100),
            prop_loss_desc character varying(250),
            CONSTRAINT prop_loss_pkey PRIMARY KEY (prop_loss_id)
        );
        ALTER TABLE public.nibrs_prop_loss_type OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_relationship_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_relationship_type'
    ) THEN
        CREATE TABLE public.nibrs_relationship_type (
            relationship_type_id smallint NOT NULL,
            relationship_type_desc text,
            relationship_type_sort_order smallint,
            CONSTRAINT relationship_type_pkey PRIMARY KEY (relationship_type_id)
        
        );
        ALTER TABLE public.nibrs_relationship_type OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_suspected_drug_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_suspected_drug_type'
    ) THEN
        CREATE TABLE public.nibrs_suspected_drug_type (
            suspected_drug_type_id smallint NOT NULL,
            suspected_drug_code character(1),
            suspected_drug_name character varying(100),
            CONSTRAINT suspected_drug_type_pkey PRIMARY KEY (suspected_drug_type_id)
        );
        ALTER TABLE public.nibrs_suspected_drug_type OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_using_list; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_using_list'
    ) THEN
        CREATE TABLE public.nibrs_using_list (
            suspect_using_id smallint NOT NULL,
            suspect_using_code character(1),
            suspect_using_name character varying(100),
            sort_order smallint,
            CONSTRAINT using_list_pkey PRIMARY KEY (suspect_using_id)
        );
        ALTER TABLE public.nibrs_using_list OWNER TO postgres;
    END IF;
END $$;


--
-- Name: nibrs_victim_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_victim_type'
    ) THEN
        CREATE TABLE public.nibrs_victim_type (
            victim_type_id smallint NOT NULL,
            victim_type_code character(1),
            victim_type_name character varying(100),
            sort_order smallint,
            CONSTRAINT victim_type_pkey PRIMARY KEY (victim_type_id)
        );
        ALTER TABLE public.nibrs_victim_type OWNER TO postgres;
    END IF;
END $$;


--
-- Name: ref_agency_type; Type: TABLE; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'ref_agency_type'
    ) THEN
        CREATE TABLE public.ref_agency_type (
            agency_type_id smallint NOT NULL,
            agency_type_name text,
            default_pop_family_id text,
            change_user text,
            CONSTRAINT ref_agency_type_pkey PRIMARY KEY (agency_type_id)
        );
        ALTER TABLE public.ref_agency_type OWNER TO postgres;
    END IF;
END $$;



        
        

--
-- Data for Name: nibrs_age; Type: TABLE DATA; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_age'
    ) THEN
        INSERT INTO public.nibrs_age VALUES (1, 'NN', 'Under 24 Hours') ON CONFLICT (age_id) DO NOTHING;
        INSERT INTO public.nibrs_age VALUES (2, 'NB', '1-6 Days Old') ON CONFLICT (age_id) DO NOTHING;
        INSERT INTO public.nibrs_age VALUES (3, 'BB', '7-364 Days Old') ON CONFLICT (age_id) DO NOTHING;
        INSERT INTO public.nibrs_age VALUES (4, '00', 'Unknown') ON CONFLICT (age_id) DO NOTHING;
        INSERT INTO public.nibrs_age VALUES (5, 'AG', 'Age in Years') ON CONFLICT (age_id) DO NOTHING;
        INSERT INTO public.nibrs_age VALUES (6, '99', 'Over 98 Years Old') ON CONFLICT (age_id) DO NOTHING;
        INSERT INTO public.nibrs_age VALUES (0, 'NS', 'Not Specified') ON CONFLICT (age_id) DO NOTHING;
    END IF;
END $$;

--
-- Data for Name: nibrs_bias_list; Type: TABLE DATA; Schema: public; Owner: postgres
--
DO $$ BEGIN
    IF EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_bias_list'
    ) THEN
        INSERT INTO public.nibrs_bias_list VALUES (1, '11', 'Anti-White', 'Race/Ethnicity/Ancestry', 'Anti-White', 11, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (2, '12', 'Anti-Black or African American', 'Race/Ethnicity/Ancestry', 'Anti-Black or African American', 12, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (3, '13', 'Anti-American Indian or Alaska Native', 'Race/Ethnicity/Ancestry', 'Anti-American Indian or Alaska Native', 13, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (4, '14', 'Anti-Asian', 'Race/Ethnicity/Ancestry', 'Anti-Asian', 14, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (5, '15', 'Anti-Multi-Racial Group', 'Race/Ethnicity/Ancestry', 'Anti-Multiple Races, Group', 15, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (6, '21', 'Anti-Jewish', 'Religion', 'Anti-Jewish', 21, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (7, '22', 'Anti-Catholic', 'Religion', 'Anti-Catholic', 22, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (8, '23', 'Anti-Protestant', 'Religion', 'Anti-Protestant', 23, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (9, '24', 'Anti-Islamic (Muslim)', 'Religion', 'Anti-Islamic (Muslim)', 24, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (10, '25', 'Anti-Other Religion', 'Religion', 'Anti-Other Religion', 25, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (11, '26', 'Anti-Multi-Religious Group', 'Religion', 'Anti-Multiple Religions, Group', 26, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (12, '27', 'Anti-Atheist/Agnosticism', 'Religion', 'Anti-Atheism/Agnosticism', 35, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (13, '31', 'Anti-Arab', 'Race/Ethnicity/Ancestry', 'Anti-Arab', 17, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (14, '32', 'Anti-Hispanic or Latino', 'Race/Ethnicity/Ancestry', 'Anti-Hispanic or Latino', 18, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (15, '33', 'Anti-Not Hispanic or Latino', 'Race/Ethnicity/Ancestry', 'Anti-Other Race/Ethnicity/Ancestry', 19, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (16, '41', 'Anti-Male Homosexual (Gay)', 'Sexual Orientation', 'Anti-Gay (Male)', 41, 3, 40) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (17, '42', 'Anti-Female Homosexual (Lesbian)', 'Sexual Orientation', 'Anti-Lesbian (Female)', 42, 3, 40) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (18, '43', 'Anti-Lesbian, Gay, Bisexual, or Transgender, Mixed Group (LGBT)', 'Sexual Orientation', 'Anti-Lesbian, Gay, Bisexual, or Transgender (Mixed Group)', 43, 3, 40) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (19, '44', 'Anti-Heterosexual', 'Sexual Orientation', 'Anti-Heterosexual', 44, 3, 40) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (20, '45', 'Anti-Bisexual', 'Sexual Orientation', 'Anti-Bisexual', 45, 3, 40) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (21, '88', 'None', 'None/Unknown', 'None (no bias)', 88, 7, 90) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (22, '99', 'Unknown', 'None/Unknown', 'Unknown (offender''s motivation not known)', 99, 7, 90) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (23, '16', 'Anti-Native Hawaiian or Other Pacific Islander', 'Race/Ethnicity/Ancestry', 'Anti-Native Hawaiian or Other Pacific Islander', 16, 1, 10) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (24, '51', 'Anti-Physical Disability', 'Disability', 'Anti-Physical Disability', 51, 4, 50) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (25, '52', 'Anti-Mental Disability', 'Disability', 'Anti-Mental Disability', 52, 4, 50) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (26, '61', 'Anti-Male', 'Gender', 'Anti-Male', 61, 5, 60) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (27, '62', 'Anti-Female', 'Gender', 'Anti-Female', 62, 5, 60) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (28, '71', 'Anti-Transgender', 'Gender Identity', 'Anti-Transgender', 71, 6, 70) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (29, '72', 'Anti-Gender Non-Conforming', 'Gender Identity', 'Anti-Gender Non-Conforming', 72, 6, 70) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (30, '28', 'Anti-Mormon', 'Religion', 'Anti-Mormon', 28, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (31, '29', 'Anti-Jehovah''s Witness', 'Religion', 'Anti-Jehovah''s Witness', 29, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (32, '81', 'Anti-Eastern Orthodox', 'Religion', 'Anti-Eastern Orthodox (Russian, Greek, Other)', 30, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (33, '82', 'Anti-Other Christian', 'Religion', 'Anti-Other Christian', 31, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (34, '83', 'Anti-Buddhist', 'Religion', 'Anti-Buddhist', 32, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (35, '84', 'Anti-Hindu', 'Religion', 'Anti-Hindu', 33, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
        INSERT INTO public.nibrs_bias_list VALUES (36, '85', 'Anti-Sikh', 'Religion', 'Anti-Sikh', 34, 2, 20) ON CONFLICT (bias_id) DO NOTHING;
    END IF;
END $$;

--
-- Data for Name: nibrs_circumstances; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public.nibrs_circumstances VALUES (1, 'A', 1, 'Argument') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (2, 'A', 2, 'Assault on Law Enforcement Officer') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (3, 'A', 3, 'Drug Dealing') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (4, 'A', 4, 'Gangland') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (5, 'A', 5, 'Juvenile Gang') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (6, 'A', 6, 'Lovers'' Quarrel') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (7, 'A', 7, 'Mercy Killing') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (8, 'A', 8, 'Other Felony Involved') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (9, 'A', 9, 'Other Circumstances') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (10, 'A', 10, 'Unknown Circumstances') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (11, 'J', 20, 'Criminal Killed by Private Citizen') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (12, 'J', 21, 'Criminal Killed by Police Officer') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (13, 'N', 30, 'Child Playing With Weapon') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (14, 'N', 31, 'Gun-Cleaning Accident') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (15, 'N', 32, 'Hunting Accident') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (16, 'N', 33, 'Other Negligent Weapon Handling') ON CONFLICT (circumstances_id) DO NOTHING;
INSERT INTO public.nibrs_circumstances VALUES (17, 'N', 34, 'Other Negligent Killings') ON CONFLICT (circumstances_id) DO NOTHING;


--
-- Data for Name: nibrs_cleared_except; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_cleared_except VALUES (1, 'A', 'Death of Offender', 'Death of Offender', 1) ON CONFLICT (cleared_except_id) DO NOTHING;
INSERT INTO public.nibrs_cleared_except VALUES (2, 'B', 'Prosecution Declined', 'Prosecution Declined (by the prosecutor for a reason other than lack of probable cause)', 2) ON CONFLICT (cleared_except_id) DO NOTHING;
INSERT INTO public.nibrs_cleared_except VALUES (3, 'C', 'In Custody of Other Jurisdiction', 'In Custody of Other Jurisdiction', 3) ON CONFLICT (cleared_except_id) DO NOTHING;
INSERT INTO public.nibrs_cleared_except VALUES (4, 'D', 'Victim Refused to Cooperate', 'Victim Refused to Cooperate (in the prosecution)', 4) ON CONFLICT (cleared_except_id) DO NOTHING;
INSERT INTO public.nibrs_cleared_except VALUES (5, 'E', 'Juvenile/No Custody', 'Juvenile/No Custody (the handling of a juvenile without taking him/her into custody, but rather by oral or written notice given to the parents or legal guardian in a case involving a minor offense, such as petty larceny)', 5) ON CONFLICT (cleared_except_id) DO NOTHING;
INSERT INTO public.nibrs_cleared_except VALUES (6, 'N', 'Not Applicable', 'Not Applicable (not cleared exceptionally)', 6) ON CONFLICT (cleared_except_id) DO NOTHING;


--
-- Data for Name: nibrs_criminal_act_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_criminal_act_type VALUES (1, 'B', 'Buying/Receiving', 'Buying/Receiving', 2) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (2, 'C', 'Cultivating/Manufacturing/Publishing', 'Cultivating/Manufacturing/Publishing (i.e., production of any type)', 3) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (3, 'D', 'Distributing/Selling', 'Distributing/Selling', 4) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (4, 'E', 'Exploiting Children', 'Exploiting Children', 6) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (5, 'O', 'Operating/Promoting/Assisting', 'Operating/Promoting/Assisting', 8) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (6, 'P', 'Possessing/Concealing', 'Possessing/Concealing', 9) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (7, 'T', 'Transporting/Transmitting/Importing', 'Transporting/Transmitting/Importing', 11) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (8, 'U', 'Using/Consuming', 'Using/Consuming', 12) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (9, 'N', 'None/Unknown', 'None/Unknown', 15) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (10, 'G', 'Other Gang', 'Other Gang', 14) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (11, 'J', 'Juvenile Gang', 'Juvenile Gang', 13) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (12, 'A', 'Simple/Gross Neglect', 'Simple/Gross Neglect (unintentionally, intentionally, or knowingly failing to provide food, water, shelter, veterinary care, hoarding, etc.)', 1) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (13, 'F', 'Organized Abuse', 'Organized Abuse (Dog Fighting and Cock Fighting)', 5) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (14, 'I', 'Intentional Abuse and Torture', 'Intentional Abuse and Torture (tormenting, mutilating, maiming, poisoning, or abandonment)', 7) ON CONFLICT (criminal_act_id) DO NOTHING;
INSERT INTO public.nibrs_criminal_act_type VALUES (15, 'S', 'Animal Sexual Abuse', 'Animal Sexual Abuse (Bestiality)', 10) ON CONFLICT (criminal_act_id) DO NOTHING;


--
-- Data for Name: nibrs_drug_measure_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_drug_measure_type VALUES (1, 'GM', 'Gram') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (2, 'KG', 'Kilogram') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (3, 'OZ', 'Ounce') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (4, 'LB', 'Pound') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (5, 'ML', 'Milliliter') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (6, 'LT', 'Liter') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (7, 'FO', 'Fluid Ounce') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (8, 'GL', 'Gallon') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (9, 'DU', 'Dosage Unit') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (10, 'NP', 'Number of Plants') ON CONFLICT (drug_measure_type_id) DO NOTHING;
INSERT INTO public.nibrs_drug_measure_type VALUES (11, 'XX', 'Not Reported') ON CONFLICT (drug_measure_type_id) DO NOTHING;


--
-- Data for Name: nibrs_ethnicity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_ethnicity VALUES (1, 'H', 'Hispanic or Latino') ON CONFLICT (ethnicity_id) DO NOTHING;
INSERT INTO public.nibrs_ethnicity VALUES (2, 'N', 'Not Hispanic or Latino') ON CONFLICT (ethnicity_id) DO NOTHING;
INSERT INTO public.nibrs_ethnicity VALUES (3, 'U', 'Unknown') ON CONFLICT (ethnicity_id) DO NOTHING;
INSERT INTO public.nibrs_ethnicity VALUES (4, 'M', 'Multiple') ON CONFLICT (ethnicity_id) DO NOTHING;


--
-- Data for Name: nibrs_injury; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_injury VALUES (1, 'B', 'Apparent Broken Bones') ON CONFLICT (injury_id) DO NOTHING;
INSERT INTO public.nibrs_injury VALUES (2, 'I', 'Possible Internal Injury') ON CONFLICT (injury_id) DO NOTHING;
INSERT INTO public.nibrs_injury VALUES (3, 'L', 'Severe Laceration') ON CONFLICT (injury_id) DO NOTHING;
INSERT INTO public.nibrs_injury VALUES (4, 'M', 'Minor Injury') ON CONFLICT (injury_id) DO NOTHING;
INSERT INTO public.nibrs_injury VALUES (5, 'N', 'None') ON CONFLICT (injury_id) DO NOTHING;
INSERT INTO public.nibrs_injury VALUES (6, 'O', 'Other Major Injury') ON CONFLICT (injury_id) DO NOTHING;
INSERT INTO public.nibrs_injury VALUES (7, 'T', 'Loss of Teeth') ON CONFLICT (injury_id) DO NOTHING;
INSERT INTO public.nibrs_injury VALUES (8, 'U', 'Unconscious') ON CONFLICT (injury_id) DO NOTHING;


--
-- Data for Name: nibrs_justifiable_force; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_justifiable_force VALUES (1, 'A', 'Criminal Attacked Police Officer and That Officer Killed Criminal') ON CONFLICT (justifiable_force_id) DO NOTHING;
INSERT INTO public.nibrs_justifiable_force VALUES (2, 'B', 'Criminal Attacked Fellow Police Officer and Criminal Killed by Anouther Police Officer') ON CONFLICT (justifiable_force_id) DO NOTHING;
INSERT INTO public.nibrs_justifiable_force VALUES (3, 'C', 'Criminal Attacked by Civilian') ON CONFLICT (justifiable_force_id) DO NOTHING;
INSERT INTO public.nibrs_justifiable_force VALUES (4, 'D', 'Criminal Attempted Flight From a Crime') ON CONFLICT (justifiable_force_id) DO NOTHING;
INSERT INTO public.nibrs_justifiable_force VALUES (5, 'E', 'Criminal KIlled In Commision of a Crime') ON CONFLICT (justifiable_force_id) DO NOTHING;
INSERT INTO public.nibrs_justifiable_force VALUES (6, 'F', 'Criminal Resisted Arrest') ON CONFLICT (justifiable_force_id) DO NOTHING;
INSERT INTO public.nibrs_justifiable_force VALUES (7, 'G', 'Unable to Determine/Not EnoughInformation') ON CONFLICT (justifiable_force_id) DO NOTHING;
INSERT INTO public.nibrs_justifiable_force VALUES (8, 'U', 'Unknown') ON CONFLICT (justifiable_force_id) DO NOTHING;


--
-- Data for Name: nibrs_location_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_location_type VALUES (1, '01', 'Air/Bus/Train Terminal', 2) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (2, '02', 'Bank/Savings and Loan', 7) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (3, '03', 'Bar/Nightclub', 8) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (4, '04', 'Church/Synagogue/Temple/Mosque', 10) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (5, '05', 'Commercial/Office Building', 11) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (6, '06', 'Construction Site', 13) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (7, '07', 'Convenience Store', 14) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (8, '08', 'Department/Discount Store', 17) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (10, '10', 'Field/Woods', 21) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (11, '11', 'Government/Public Building', 23) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (12, '12', 'Grocery/Supermarket', 24) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (13, '13', 'Highway/Road/Alley/Street/Sidewalk', 25) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (14, '14', 'Hotel/Motel/Etc.', 26) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (15, '15', 'Jail/Prison/Penitentiary/Corrections Facility', 28) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (16, '16', 'Lake/Waterway/Beach', 29) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (17, '17', 'Liquor Store', 30) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (18, '18', 'Parking/Drop Lot/Garage', 33) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (19, '19', 'Rental Storage Facility', 34) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (20, '20', 'Residence/Home', 35) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (21, '21', 'Restaurant', 37) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (22, '22', 'School/College', 38) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (23, '23', 'Service/Gas Station', 41) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (24, '24', 'Specialty Store', 44) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (25, '25', 'Other/Unknown', 98) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (26, '37', 'Abandoned/Condemned Structure', 1) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (27, '38', 'Amusement Park', 3) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (28, '39', 'Arena/Stadium/Fairgrounds/Coliseum', 4) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (29, '40', 'ATM Separate from Bank', 5) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (30, '41', 'Auto Dealership New/Used', 6) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (31, '42', 'Camp/Campground', 9) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (32, '44', 'Daycare Facility', 16) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (33, '45', 'Dock/Wharf/Freight/Modal Terminal', 18) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (34, '46', 'Farm Facility', 20) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (35, '47', 'Gambling Facility/Casino/Race Track', 22) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (36, '48', 'Industrial Site', 27) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (37, '49', 'Military Installation', 31) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (38, '50', 'Park/Playground', 32) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (39, '51', 'Rest Area', 36) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (40, '52', 'School-College/University', 39) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (41, '53', 'School-Elementary/Secondary', 40) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (42, '54', 'Shelter-Mission/Homeless', 42) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (43, '55', 'Shopping Mall', 43) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (44, '56', 'Tribal Lands', 45) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (45, '57', 'Community Center', 12) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (46, '09', 'Drug Store/Doctor''s Office/Hospital', 19) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (47, '58', 'Cyberspace', 15) ON CONFLICT (location_id) DO NOTHING;
INSERT INTO public.nibrs_location_type VALUES (0, '00', 'Not Specified', 99) ON CONFLICT (location_id) DO NOTHING;


--
-- Data for Name: nibrs_offense_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_offense_type VALUES (1, '09C', 'Justifiable Homicide', 'Person', 'N', 'N', '', 'Homicide Offenses', 'A    ', 'VICTIM', '99', '12', 'Justifiable Homicide', '', '', '1', 'Other', '170', '2') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (2, '26A', 'False Pretenses/Swindle/Confidence Game', 'Property', 'Y', 'Y', '', 'Fraud Offenses', 'A    ', 'OFFENSE', '99', '111', 'Swindle', '01-JAN-91', '01-JAN-91', '2', 'Other', '270', '14') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (3, '36B', 'Statutory Rape', 'Person', 'N', 'Y', '', 'Sex Offenses, Non-forcible', 'A    ', 'VICTIM', '99', '134', 'Statutory Rape', '01-JAN-91', '', '1', 'Other', '170', '6') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (4, '11C', 'Sexual Assault With An Object', 'Person', 'N', 'Y', '02', 'Sex Offenses', 'A    ', 'VICTIM', '20', '23', 'Sexual Assault With Object', '01-JAN-91', '', '1', 'Rape', '120', '5') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (5, '290', 'Destruction/Damage/Vandalism of Property', 'Property', 'N', 'Y', '11', 'Destruction/Damage/Vandalism of Property', 'A    ', 'OFFENSE', '99', '123', 'Vandalism', '01-JAN-91', '', '2', 'Destruction/Damage/Vandalism of Property', '260', '11') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (6, '90F', 'Family Offenses, Nonviolent', 'Person', 'N', 'N', '', 'Family Offenses, Nonviolent', 'B    ', 'VICTIM', '99', '206', 'Family Offenses - Nonviolent', '', '', '1', 'Other', '170', '30') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (7, '23G', 'Theft of Motor Vehicle Parts or Accessories', 'Property', 'N', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '76', 'Theft of Motor Vehicle Parts', '', '', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (8, '370', 'Pornography/Obscene Material', 'Society', 'N', 'Y', '', 'Pornography/Obscene Material', 'A    ', 'OFFENSE', '99', '141', 'Pornography', '01-JAN-91', '', '3', 'Crimes against society', '300', '22') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (9, '39D', 'Sports Tampering', 'Society', 'N', 'Y', '', 'Gambling Offenses', 'A    ', 'OFFENSE', '99', '154', 'Sports Tampering', '01-JAN-91', '', '3', 'Crimes against society', '300', '21') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (10, '90D', 'Driving Under the Influence', 'Society', 'N', 'N', '', 'Driving Under the Influence', 'B    ', 'OFFENSE', '99', '204', 'DUI', '', '', '3', 'Crimes against society', '300', '28') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (11, '250', 'Counterfeiting/Forgery', 'Property', 'N', 'Y', '', 'Counterfeiting/Forgery', 'A    ', 'OFFENSE', '99', '104', 'Forgery', '01-JAN-91', '', '2', 'Other', '270', '10') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (12, '26D', 'Welfare Fraud', 'Property', 'N', 'Y', '', 'Fraud Offenses', 'A    ', 'OFFENSE', '99', '114', 'Welfare Fraud', '01-JAN-91', '', '2', 'Other', '270', '14') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (13, '23A', 'Pocket-picking', 'Property', 'N', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '70', 'Pocket-picking', '', '', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (14, '23F', 'Theft From Motor Vehicle', 'Property', 'Y', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '75', 'Theft From MV', '', '01-JAN-91', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (15, '40B', 'Assisting or Promoting Prostitution', 'Society', 'N', 'Y', '', 'Prostitution Offenses', 'A    ', 'OFFENSE', '99', '162', 'Promoting Prostitution', '01-JAN-91', '', '3', 'Crimes against society', '300', '23') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (16, '35A', 'Drug/Narcotic Violations', 'Society', 'N', 'Y', '', 'Drug/Narcotic Offenses', 'A    ', 'OFFENSE', '99', '131', 'Drug Violations', '01-JAN-91', '', '3', 'Crimes against society', '300', '20') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (17, '26E', 'Wire Fraud', 'Property', 'Y', 'Y', '', 'Fraud Offenses', 'A    ', 'OFFENSE', '99', '115', 'Wire Fraud', '01-JAN-91', '01-JAN-91', '2', 'Other', '270', '14') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (18, '23B', 'Purse-snatching', 'Property', 'N', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '71', 'Purse-snatching', '', '', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (19, '90I', 'Runaway', 'Not a Crime', 'N', 'N', '', 'Other Offenses', '     ', 'N/A', '', '', 'Runaway', '', '', '4', 'Runaway', '400', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (20, '200', 'Arson', 'Property', 'N', 'Y', '08', 'Arson', 'A    ', 'OFFENSE', '99', '102', 'Arson', '01-JAN-91', '', '2', 'Arson', '250', '7') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (21, '240', 'Motor Vehicle Theft', 'Property', 'Y', 'Y', '07', 'Motor Vehicle Theft', 'A    ', 'SPECIAL', '60', '60', 'Motor Vehicle Theft', '01-JAN-91', '01-JAN-91', '2', 'Motor Vehicle Theft', '240', '16') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (22, '90E', 'Drunkenness', 'Society', 'N', 'N', '', 'Drunkenness', 'B    ', 'OFFENSE', '99', '205', 'Drunkenness', '', '', '3', 'Crimes against society', '300', '29') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (23, '23C', 'Shoplifting', 'Property', 'N', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '72', 'Shoplifting', '', '', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (24, '39B', 'Operating/Promoting/Assisting Gambling', 'Society', 'N', 'Y', '', 'Gambling Offenses', 'A    ', 'OFFENSE', '99', '152', 'Gambling', '01-JAN-91', '', '3', 'Crimes against society', '300', '21') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (25, '90A', 'Bad Checks', 'Property', 'N', 'N', '', 'Bad Checks', 'B    ', 'OFFENSE', '99', '201', 'Bad Checks', '', '', '2', 'Other', '270', '25') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (26, '210', 'Extortion/Blackmail', 'Property', 'Y', 'Y', '', 'Extortion/Blackmail', 'A    ', 'OFFENSE', '99', '103', 'Extortion', '01-JAN-91', '01-JAN-91', '2', 'Other', '270', '13') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (27, '13A', 'Aggravated Assault', 'Person', 'N', 'Y', '04', 'Assault Offenses', 'A    ', 'VICTIM', '40', '40', 'Aggravated Assault', '01-JAN-91', '', '1', 'Aggravated Assault', '130', '1') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (28, '280', 'Stolen Property Offenses', 'Property', 'N', 'Y', '', 'Stolen Property Offenses', 'A    ', 'OFFENSE', '99', '122', 'Stolen Property', '01-JAN-91', '', '2', 'Other', '270', '18') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (29, '100', 'Kidnapping/Abduction', 'Person', 'N', 'Y', '', 'Kidnapping/Abduction', 'A    ', 'VICTIM', '99', '101', 'Kidnapping', '01-JAN-91', '', '1', 'Other', '170', '4') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (30, '40A', 'Prostitution', 'Society', 'N', 'Y', '', 'Prostitution Offenses', 'A    ', 'OFFENSE', '99', '161', 'Prostitution', '01-JAN-91', '', '3', 'Crimes against society', '300', '23') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (31, '39A', 'Betting/Wagering', 'Society', 'N', 'Y', '', 'Gambling Offenses', 'A    ', 'OFFENSE', '99', '151', 'Betting', '01-JAN-91', '', '3', 'Crimes against society', '300', '21') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (32, '09A', 'Murder and Nonnegligent Manslaughter', 'Person', 'N', 'Y', '01', 'Homicide Offenses', 'A    ', 'VICTIM', '10', '10', 'Murder', '01-JAN-91', '', '1', 'Murder and Nonnegligent Manslaughter', '110', '2') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (33, '90H', 'Peeping Tom', 'Person', 'N', 'N', '', 'Peeping Tom', 'B    ', 'VICTIM', '99', '208', 'Peeping Tom', '', '', '1', 'Other', '170', '32') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (34, '90J', 'Trespass of Real Property', 'Society', 'N', 'N', '', 'Trespass of Real Property', 'B    ', 'OFFENSE', '99', '209', 'Trespass', '', '', '3', 'Crimes against society', '300', '33') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (35, '35B', 'Drug Equipment Violations', 'Society', 'N', 'Y', '', 'Drug/Narcotic Offenses', 'A    ', 'OFFENSE', '99', '132', 'Drug Equipment', '01-JAN-91', '', '3', 'Crimes against society', '300', '20') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (36, '11A', 'Rape', 'Person', 'N', 'Y', '02', 'Sex Offenses', 'A    ', 'VICTIM', '20', '21', 'Rape', '01-JAN-91', '', '1', 'Rape', '120', '5') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (37, '270', 'Embezzlement', 'Property', 'Y', 'Y', '', 'Embezzlement', 'A    ', 'OFFENSE', '99', '121', 'Embezzlement', '01-JAN-91', '01-JAN-91', '2', 'Other', '270', '12') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (38, '09B', 'Negligent Manslaughter', 'Person', 'N', 'Y', '', 'Homicide Offenses', 'A    ', 'VICTIM', '11', '11', 'Negligent Manslaughter', '01-JAN-91', '', '1', 'Other', '170', '2') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (39, '520', 'Weapon Law Violations', 'Society', 'N', 'Y', '', 'Weapon Law Violations', 'A    ', 'OFFENSE', '99', '172', 'Weapon Law', '01-JAN-91', '', '3', 'Crimes against society', '300', '24') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (40, '120', 'Robbery', 'Property', 'Y', 'Y', '03', 'Robbery', 'A    ', 'OFFENSE', '30', '30', 'Robbery', '01-JAN-91', '01-JAN-91', '2', 'Robbery', '210', '17') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (41, '26B', 'Credit Card/Automated Teller Machine Fraud', 'Property', 'Y', 'Y', '', 'Fraud Offenses', 'A    ', 'OFFENSE', '99', '112', 'Credit Card - ATM Fraud', '01-JAN-91', '01-JAN-91', '2', 'Other', '270', '14') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (42, '90B', 'Curfew/Loitering/Vagrancy Violations', 'Society', 'N', 'N', '', 'Curfew/Loitering/Vagrancy Violations', 'B    ', 'OFFENSE', '99', '202', 'Loitering', '', '', '3', 'Crimes against society', '300', '26') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (43, '11B', 'Sodomy', 'Person', 'N', 'Y', '02', 'Sex Offenses', 'A    ', 'VICTIM', '20', '22', 'Sodomy', '01-JAN-91', '', '1', 'Rape', '120', '5') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (44, '13C', 'Intimidation', 'Person', 'N', 'Y', '10', 'Assault Offenses', 'A    ', 'VICTIM', '80', '82', 'Intimidation', '01-JAN-91', '', '1', 'Intimidation', '150', '1') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (45, '23H', 'All Other Larceny', 'Property', 'Y', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '77', 'All Other Larceny', '', '01-JAN-91', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (46, '26C', 'Impersonation', 'Property', 'Y', 'Y', '', 'Fraud Offenses', 'A    ', 'OFFENSE', '99', '113', 'Impersonation', '01-JAN-91', '01-JAN-91', '2', 'Other', '270', '14') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (47, '23D', 'Theft From Building', 'Property', 'Y', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '73', 'Theft From Building', '', '01-JAN-91', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (48, '90Z', 'All Other Offenses', 'Society', 'N', 'N', '', 'All Other Offenses', 'B    ', 'OFFENSE', '99', '210', 'All Other Offenses', '', '', '3', 'Crimes against society', '300', '34') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (49, '220', 'Burglary/Breaking & Entering', 'Property', 'Y', 'Y', '05', 'Burglary/Breaking & Entering', 'A    ', 'SPECIAL', '50', '50', 'Burglary', '01-JAN-91', '01-JAN-91', '2', 'Burglary/Breaking & Entering', '220', '9') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (50, '23E', 'Theft From Coin-Operated Machine or Device', 'Property', 'N', 'N', '', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '70', '74', 'Theft From Machine', '', '', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (51, '13B', 'Simple Assault', 'Person', 'N', 'Y', '09', 'Assault Offenses', 'A    ', 'VICTIM', '80', '81', 'Simple Assault', '01-JAN-91', '', '1', 'Simple Assault', '140', '1') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (52, '90G', 'Liquor Law Violations', 'Society', 'N', 'N', '', 'Liquor Law Violations', 'B    ', 'OFFENSE', '99', '207', 'Liquor Law', '', '', '3', 'Crimes against society', '300', '31') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (53, '90C', 'Disorderly Conduct', 'Society', 'N', 'N', '', 'Disorderly Conduct', 'B    ', 'OFFENSE', '99', '203', 'Disorderly Conduct', '', '', '3', 'Crimes against society', '300', '27') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (54, '39C', 'Gambling Equipment Violation', 'Society', 'N', 'Y', '', 'Gambling Offenses', 'A    ', 'OFFENSE', '99', '153', 'Gambling Equipment', '01-JAN-91', '', '3', 'Crimes against society', '300', '21') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (55, '36A', 'Incest', 'Person', 'N', 'Y', '', 'Sex Offenses, Non-forcible', 'A    ', 'VICTIM', '99', '133', 'Incest', '01-JAN-91', '', '1', 'Other', '170', '6') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (56, '11D', 'Fondling', 'Person', 'N', 'Y', '02', 'Sex Offenses', 'A    ', 'VICTIM', '99', '24', 'Fondling', '01-JAN-91', '', '1', 'Other', '170', '5') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (57, '510', 'Bribery', 'Property', 'Y', 'Y', '', 'Bribery', 'A    ', 'OFFENSE', '99', '171', 'Bribery', '01-JAN-91', '01-JAN-91', '2', 'Other', '270', '8') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (58, '23*', 'Not Specified', 'Property', 'N', 'Y', '06', 'Larceny/Theft Offenses', 'A    ', 'OFFENSE', '99', '79', 'Not Specified', '01-JAN-91', '', '2', 'Larceny-theft', '230', '15') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (59, '64A', 'Human Trafficking, Commercial Sex Acts', 'Person', 'N', 'Y', '12', 'Human Trafficking', 'A    ', 'VICTIM', '99', '181', 'HT Commercial Sex Acts', '01-JAN-91', '', '1', 'Human Trafficking, Commercial Sex Acts', '160', '3') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (60, '64B', 'Human Trafficking, Involuntary Servitude', 'Person', 'N', 'Y', '13', 'Human Trafficking', 'A    ', 'VICTIM', '99', '182', 'HT Involuntary Servitude', '01-JAN-91', '', '1', 'Other', '170', '3') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (61, '40C', 'Purchasing Prostitution', 'Society', 'N', 'Y', '', 'Prostitution Offenses', 'A    ', 'OFFENSE', '99', '163', 'Purchasing Prostitution', '01-JAN-91', '', '3', 'Crimes against society', '300', '23') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (62, '720', 'Animal Cruelty', 'Society', 'N', 'N', '', 'Animal Cruelty', 'A    ', 'OFFENSE', '99', '191', 'Animal Cruelty', '', '', '3', 'Crimes against society', '300', '19') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (63, '26F', 'Identity Theft', 'Property', 'Y', 'Y', '', 'Fraud Offenses', 'A    ', 'OFFENSE', '99', '116', 'Identity Theft', '01-JAN-91', '01-JAN-19', '2', 'Other', '270', '14') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (64, '26G', 'Hacking/Computer Invasion', 'Property', 'Y', 'Y', '', 'Fraud Offenses', 'A    ', 'OFFENSE', '99', '117', 'Computer Hacking', '01-JAN-91', '01-JAN-19', '2', 'Other', '270', '14') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (65, '90K', 'Failure to Appear', 'Society', 'N', 'N', '', 'Other Offenses', 'B    ', 'OFFENSE', '99', '215', 'Failure to Appear', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (66, '90L', 'Federal Resource Violations', 'Society', 'N', 'N', '', 'Other Offenses', 'B    ', 'OFFENSE', '99', '216', 'Federal Resource Violations', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (67, '90M', 'Perjury', 'Society', 'N', 'N', '', 'Other Offenses', 'B    ', 'OFFENSE', '99', '217', 'Perjury', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (68, '26H', 'Money Laundering', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Money Laundering', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (69, '101', 'Treason', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Treason', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (70, '103', 'Espionage', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Espionage', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (71, '30A', 'Illegal Entry into the United States', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Illegal Entry into the US', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (72, '30B', 'False Citizenship', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'False Citizenship', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (73, '30C', 'Smuggling Aliens', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Smuggling Aliens', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (74, '30D', 'Re-entry after Deportation', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Re-entry after Deportation', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (75, '360', 'Failure to Register as a Sex Offender', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Sex Offender-Fail to Register', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (76, '49A', 'Harboring Escapee/Concealing from Arrest', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Harboring Escapee', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (77, '49B', 'Flight to Avoid Prosecution', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Flight to Avoid Prosecution', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (78, '49C', 'Flight to Avoid Deportation', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Flight to Avoid Deportation', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (79, '521', 'Violation of National Firearm Act of 1934', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Violation of Nat. Firearm Act', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (80, '522', 'Weapons of Mass Destruction', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Weapons of Mass Destruction', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (81, '526', 'Explosives Violation', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Explosives Violation', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (82, '58A', 'Import Violations', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Import Violations', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (83, '58B', 'Export Violations', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Export Violations', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (84, '61A', 'Federal Liquor Offenses', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Federal Liquor Offenses', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (85, '61B', 'Federal Tobacco Offenses', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Federal Tobacco Offenses', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;
INSERT INTO public.nibrs_offense_type VALUES (86, '620', 'Wildlife Trafficking', 'Society', 'N', 'N', '', 'Other Offenses', 'A    ', 'OFFENSE', '99', '183', 'Wildlife Trafficking', '', '', '3', 'Crimes against society', '300', '35') ON CONFLICT (offense_type_id) DO NOTHING;


--
-- Data for Name: nibrs_prop_desc_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_prop_desc_type VALUES (1, '01', 'Aircraft') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (2, '02', 'Alcohol') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (3, '03', 'Automobile') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (4, '04', 'Bicycles') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (5, '05', 'Buses') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (6, '06', 'Clothes/ Furs') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (7, '07', 'Computer Hard/ Software') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (8, '08', 'Consumable Goods') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (9, '09', 'Credit/ Debit cards') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (10, '10', 'Drugs/ Narcotics') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (11, '11', 'Drug Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (12, '12', 'Farm Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (13, '13', 'Firearms') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (14, '14', 'Gambling Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (15, '15', 'Industrial Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (16, '16', 'Household Goods') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (17, '17', 'Jewelry/ Precious Metals') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (18, '18', 'Livestock') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (19, '19', 'Merchandise') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (20, '20', 'Money') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (21, '21', 'Negotiable Instruments') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (22, '22', 'Non Negotiable Instruments') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (23, '23', 'Office Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (24, '24', 'Other Motor Vehicles') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (25, '25', 'Purse/ Wallet') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (26, '26', 'Radio/ TV/ VCR') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (27, '27', 'Recordings') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (28, '28', 'Recreational Vehicles') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (29, '29', 'Structure/ Single dwelling') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (30, '30', 'Structure/ Other residence') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (31, '31', 'Structure/ Other commercial') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (32, '32', 'Structure/ Other industrial') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (33, '33', 'Structure/ Public') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (34, '34', 'Structure/ Storage') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (35, '35', 'Structure/ Other') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (36, '36', 'Tools') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (37, '37', 'Trucks') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (38, '38', 'Vehicle Parts') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (39, '39', 'Watercraft') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (40, '41', 'Aircraft Parts/ Accessories') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (41, '42', 'Artistic Supplies/ Accessories') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (42, '43', 'Building Materials') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (43, '44', 'Camping/ Hunting/ Fishing Equipment/ Supplies') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (44, '45', 'Chemicals') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (45, '46', 'Collections/ Collectibles') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (46, '47', 'Crops') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (47, '48', 'Documents/ Personal or Business') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (48, '49', 'Explosives') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (49, '59', 'Firearm Accessories') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (50, '64', 'Fuel') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (51, '65', 'Identity Documents') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (52, '66', 'Identity-Intangible') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (53, '67', 'Law Enforcement Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (54, '68', 'Lawn/ Yard/ Garden Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (55, '69', 'Logging Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (56, '70', 'Medical/ Medical Lab Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (57, '71', 'Metals, Non-Precious') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (58, '72', 'Musical Instruments') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (59, '73', 'Pets') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (60, '74', 'Photographic/ Optical Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (61, '75', 'Portable Electronic Communications') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (62, '76', 'Recreational/ Sports Equipment') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (63, '77', 'Other') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (64, '78', 'Trailers') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (65, '79', 'Watercraft Equipment/ Parts/ Accessories') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (66, '80', 'Weapons-Other') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (67, '88', 'Pending Inventory') ON CONFLICT (prop_desc_id) DO NOTHING;
INSERT INTO public.nibrs_prop_desc_type VALUES (68, '99', 'Special') ON CONFLICT (prop_desc_id) DO NOTHING;


--
-- Data for Name: nibrs_prop_loss_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_prop_loss_type VALUES (1, 'None', 'None') ON CONFLICT (prop_loss_id) DO NOTHING;
INSERT INTO public.nibrs_prop_loss_type VALUES (2, 'Burned', 'Burned (includes damage caused in fighting the fire)') ON CONFLICT (prop_loss_id) DO NOTHING;
INSERT INTO public.nibrs_prop_loss_type VALUES (3, 'Counterfeited/Forged', 'Counterfeited/Forged') ON CONFLICT (prop_loss_id) DO NOTHING;
INSERT INTO public.nibrs_prop_loss_type VALUES (4, 'Destroyed/Damaged/Vandalized', 'Destroyed/Damaged/Vandalized') ON CONFLICT (prop_loss_id) DO NOTHING;
INSERT INTO public.nibrs_prop_loss_type VALUES (5, 'Recovered', 'Recovered (to impound property that was previously stolen)') ON CONFLICT (prop_loss_id) DO NOTHING;
INSERT INTO public.nibrs_prop_loss_type VALUES (6, 'Seized', 'Seized (to impound property that was not previously stolen)') ON CONFLICT (prop_loss_id) DO NOTHING;
INSERT INTO public.nibrs_prop_loss_type VALUES (7, 'Stolen/Etc', 'Stolen/Etc. (includes bribed, defrauded, embezzled, extorted, ransomed, robbed, etc.)') ON CONFLICT (prop_loss_id) DO NOTHING;
INSERT INTO public.nibrs_prop_loss_type VALUES (8, 'Unknown', 'Unknown') ON CONFLICT (prop_loss_id) DO NOTHING;


--
-- Data for Name: nibrs_relationship_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_relationship_type VALUES (1, 'Family Member', 1) ON CONFLICT (relationship_type_id) DO NOTHING;
INSERT INTO public.nibrs_relationship_type VALUES (2, 'Known to Victim', 2) ON CONFLICT (relationship_type_id) DO NOTHING;
INSERT INTO public.nibrs_relationship_type VALUES (3, 'Stranger', 3) ON CONFLICT (relationship_type_id) DO NOTHING;
INSERT INTO public.nibrs_relationship_type VALUES (4, 'All Other', 4) ON CONFLICT (relationship_type_id) DO NOTHING;


--
-- Data for Name: nibrs_suspected_drug_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_suspected_drug_type VALUES (1, 'A', 'Crack Cocaine') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (2, 'B', 'Cocaine') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (3, 'C', 'Hashish') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (4, 'D', 'Heroin') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (5, 'E', 'Marijuana') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (6, 'F', 'Morphine') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (7, 'G', 'Opium') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (8, 'H', 'Other Narcotics') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (9, 'I', 'LSD') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (10, 'J', 'PCP') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (11, 'K', 'Other Hallucingens') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (12, 'L', 'Meth/ Amphetamines') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (13, 'M', 'Other Stimulants') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (14, 'N', 'Barbiturates') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (15, 'O', 'Other Depressants') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (16, 'P', 'Other Drugs') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (17, 'U', 'Unknown') ON CONFLICT (suspected_drug_type_id) DO NOTHING;
INSERT INTO public.nibrs_suspected_drug_type VALUES (18, 'X', 'More Than 3 Types') ON CONFLICT (suspected_drug_type_id) DO NOTHING;


--
-- Data for Name: nibrs_using_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_using_list VALUES (1, 'A', 'Alcohol', 1) ON CONFLICT (suspect_using_id) DO NOTHING;
INSERT INTO public.nibrs_using_list VALUES (2, 'C', 'Computer Equipment (Handheld Devices)', 2) ON CONFLICT (suspect_using_id) DO NOTHING;
INSERT INTO public.nibrs_using_list VALUES (3, 'D', 'Drugs/Narcotics', 3) ON CONFLICT (suspect_using_id) DO NOTHING;
INSERT INTO public.nibrs_using_list VALUES (4, 'N', 'Not Applicable', 4) ON CONFLICT (suspect_using_id) DO NOTHING;


--
-- Data for Name: nibrs_victim_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_victim_type VALUES (1, 'B', 'Business', 1) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (2, 'F', 'Financial Institution', 2) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (3, 'G', 'Government', 3) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (4, 'I', 'Individual', 4) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (5, 'L', 'Law Enforcement Officer', 5) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (6, 'O', 'Other', 6) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (7, 'R', 'Religious Organization', 7) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (8, 'S', 'Society/Public', 8) ON CONFLICT (victim_type_id) DO NOTHING;
INSERT INTO public.nibrs_victim_type VALUES (9, 'U', 'Unknown', 9) ON CONFLICT (victim_type_id) DO NOTHING;


--
-- Data for Name: nibrs_weapon_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nibrs_weapon_type VALUES (21, '11A', 'Firearm (Automatic)', 'N', 'Y', 'Y', 1, 2, 1, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (22, '12A', 'Handgun (Automatic)', 'N', 'Y', 'Y', 1, 4, 2, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (23, '13A', 'Rifle (Automatic)', 'N', 'Y', 'Y', 1, 6, 3, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (24, '14A', 'Shotgun (Automatic)', 'N', 'Y', 'Y', 1, 8, 4, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (25, '15A', 'Other Firearm (Automatic)', 'N', 'Y', 'Y', 1, 10, 5, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (26, '55', 'Pushed or Thrown Out Window', 'Y', 'N', 'N', 5, 54, 14, 4) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (27, '75', 'Drowning', 'Y', 'N', 'N', 5, 55, 14, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (28, '80', 'Strangulation - Include Hanging', 'Y', 'N', 'N', 5, 56, 14, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (1, '01', 'Unarmed', 'N', 'N', 'Y', 5, 51, 14, 5) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (2, '11', 'Firearm', 'Y', 'Y', 'Y', 1, 1, 1, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (3, '12', 'Handgun', 'Y', 'Y', 'Y', 1, 3, 2, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (4, '13', 'Rifle', 'Y', 'Y', 'Y', 1, 5, 3, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (5, '14', 'Shotgun', 'Y', 'Y', 'Y', 1, 7, 4, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (6, '15', 'Other Firearm', 'Y', 'Y', 'Y', 1, 9, 5, 1) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (7, '16', 'Lethal Cutting Instrument', 'N', 'N', 'Y', 5, 52, 6, 2) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (8, '17', 'Club/Blackjack/Brass Knuckles', 'N', 'N', 'Y', 5, 53, 14, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (9, '20', 'Knife/Cutting Instrument', 'Y', 'Y', 'N', 2, 21, 6, 2) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (10, '30', 'Blunt Object', 'Y', 'Y', 'N', 3, 31, 7, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (11, '35', 'Motor Vehicle/Vessel', 'N', 'Y', 'N', 3, 32, 14, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (12, '40', 'Personal Weapons', 'Y', 'Y', 'N', 4, 41, 8, 4) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (13, '50', 'Poison', 'Y', 'Y', 'N', 3, 33, 9, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (14, '60', 'Explosives', 'Y', 'Y', 'N', 3, 34, 10, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (15, '65', 'Fire/Incendiary Device', 'Y', 'Y', 'N', 3, 35, 11, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (16, '70', 'Drugs/Narcotics/Sleeping Pills', 'Y', 'Y', 'N', 3, 36, 12, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (17, '85', 'Asphyxiation', 'Y', 'Y', 'N', 3, 37, 13, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (18, '90', 'Other', 'Y', 'Y', 'N', 3, 38, 14, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (19, '95', 'Unknown', 'N', 'Y', 'N', 3, 39, 14, 3) ON CONFLICT (weapon_id) DO NOTHING;
INSERT INTO public.nibrs_weapon_type VALUES (20, '99', 'None', 'N', 'Y', 'N', 4, 42, 14, 5) ON CONFLICT (weapon_id) DO NOTHING;


--
-- Data for Name: ref_agency_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ref_agency_type VALUES (1, 'City', '2', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (2, 'County', '3', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (3, 'University or College', '2', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (4, 'State Police', '4', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (5, 'Other', '2', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (6, 'Other State Agency', '2', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (7, 'Tribal', '2', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (8, 'Federal', '2', '') ON CONFLICT (agency_type_id) DO NOTHING;
INSERT INTO public.ref_agency_type VALUES (99, 'Unknown', '2', '') ON CONFLICT (agency_type_id) DO NOTHING;


--
-- Data for Name: ref_race; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ref_race VALUES (0, 'U', 'Unknown', '98', '', '', 'Race is explicitly unknown') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (1, 'W', 'White', '10', '', '', '') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (2, 'B', 'Black or African American', '20', '', '', '') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (3, 'I', 'American Indian or Alaska Native', '30', '', '', '') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (4, 'A', 'Asian', '40', '2013', '', 'Includes Asian Indian') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (5, 'AP', 'Asian, Native Hawaiian, or Other Pacific Islander', '41', '1980', '2012', 'Includes Asian Indian') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (6, 'C', 'Chinese', '42', '1960', '1979', '') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (7, 'J', 'Japanese', '43', '1960', '1979', '') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (8, 'P', 'Native Hawaiian or Other Pacific Islander', '50', '2013', '', '') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (9, 'O', 'Other', '60', '1960', '1979', 'Includes Native Hawaiian or Other Pacific Islander and Asian Indian') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (98, 'M', 'Multiple', '70', '', '', 'Used for groups with multiple races') ON CONFLICT (race_id) DO NOTHING;
INSERT INTO public.ref_race VALUES (99, 'NS', 'Not Specified', '99', '', '', 'Race is not specified') ON CONFLICT (race_id) DO NOTHING;


--
-- Name: ix_eth2; Type: INDEX; Schema: public; Owner: postgres
--

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'ix_eth2' AND n.nspname = 'public'
  ) THEN
    CREATE INDEX ix_eth2 ON public.nibrs_ethnicity USING btree (ethnicity_id);
    END IF;
END $$;


--
-- Name: ix_lid1; Type: INDEX; Schema: public; Owner: postgres
--

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'ix_lid1' AND n.nspname = 'public'
  ) THEN
    CREATE INDEX ix_lid1 ON public.nibrs_location_type USING btree (location_id);
    END IF;
END $$;


--
-- Name: ix_nicei2; Type: INDEX; Schema: public; Owner: postgres
--

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'ix_nicei2' AND n.nspname = 'public'
  ) THEN
    CREATE INDEX ix_nicei2 ON public.nibrs_cleared_except USING btree (cleared_except_id);
    END IF;
END $$;


--
-- Name: ix_nul_suid1; Type: INDEX; Schema: public; Owner: postgres
--

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'ix_nul_suid1' AND n.nspname = 'public'
  ) THEN
    CREATE INDEX ix_nul_suid1 ON public.nibrs_using_list USING btree (suspect_using_id);
    END IF;
END $$;


--
-- Name: ix_race1; Type: INDEX; Schema: public; Owner: postgres
--

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'ix_race1' AND n.nspname = 'public'
  ) THEN
    CREATE INDEX ix_race1 ON public.ref_race USING btree (race_id);
    END IF;
END $$;


--
-- Name: TABLE nibrs_relationship_type; Type: ACL; Schema: public; Owner: postgres
--

DO $$ BEGIN
    IF EXISTS (
        SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'nibrs_age'
    ) THEN
        GRANT SELECT ON TABLE public.nibrs_age TO readaccess;
    END IF;
END $$;

--
-- PostgreSQL database dump complete
--

