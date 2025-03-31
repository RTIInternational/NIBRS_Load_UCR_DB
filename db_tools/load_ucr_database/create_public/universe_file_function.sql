DROP FUNCTION IF EXISTS ucr_prd.rpt_rti_universe_file(int4);
set schema 'ucr_prd';
CREATE OR REPLACE FUNCTION ucr_prd.rpt_rti_universe_file(a_year integer)
 RETURNS TABLE(yearly_agency_id integer, agency_id integer, data_year integer, ori character, legacy_ori character, covered_by_legacy_ori character, direct_contributor_flag character, dormant_flag character, dormant_year integer, reporting_type character, ucr_agency_name text, ncic_agency_name text, pub_agency_name text, pub_agency_unit text, agency_status character, state_id integer, state_name text, state_abbr character, state_postal_abbr character, division_code integer, division_name text, region_code integer, region_name text, region_desc text, agency_type_name text, population integer, submitting_agency_id integer, sai character, submitting_agency_name text, suburban_area_flag character, population_group_id integer, population_group_code character, population_group_desc text, parent_pop_group_code character, parent_pop_group_desc text, mip_flag character, pop_sort_order integer, summary_rape_def text, pe_reported_flag character, pe_male_officer_count integer, pe_male_civilian_count integer, "male_officer+male_civilian" integer, pe_female_officer_count integer, pe_female_civilian_count integer, "female_officer+female_civilian" integer, officer_rate numeric, employee_rate numeric, nibrs_cert_date date, nibrs_start_date date, nibrs_leoka_start_date date, nibrs_ct_start_date date, nibrs_multi_bias_start_date date, nibrs_off_eth_start_date date, covered_flag character, county_name text, msa_name text, metro_division text, publishable_flag character, participated character, nibrs_participated character, judicial_district_code character, field_office character)
 LANGUAGE sql
AS $function$
         with agency_covered_by_yearly as (
           select ramc.agency_id, ramc.data_year, ramc.covered_by_agency_id, a.ori as covered_by_ori, a.legacy_ori as covered_by_legacy_ori
           from ref_agency_month_covered ramc
           join ref_agency a on ramc.covered_by_agency_id = a.agency_id
           group by ramc.agency_id, ramc.data_year, ramc.covered_by_agency_id, a.ori, a.legacy_ori
         )
         ,
         reta_yearly as (
           select fm.agency_id, fm.data_year, count(distinct fm.data_month) as months_yearly
           from form_month fm
           join ref_agency refa on fm.agency_id  = refa.agency_id
           where fm.form_code = 'R'  or (fm.form_code = 'N' and extract(year from refa.nibrs_start_date) * 100 + extract(month from refa.nibrs_start_date) <= (fm.data_year * 100 + fm.data_month))
           group by fm.agency_id, fm.data_year
         ),
         nibrs_yearly as (
           select fm.agency_id, fm.data_year, count(distinct fm.data_month) as months_yearly
           from form_month fm
           join ref_agency refa on fm.agency_id  = refa.agency_id
           where fm.form_code = 'N' and extract(year from refa.nibrs_start_date) * 100 + extract(month from refa.nibrs_start_date) <= (fm.data_year * 100 + fm.data_month)
               group by fm.agency_id, fm.data_year
         ),
         pe_data as (
           select * from pe_employee_data ped
           join form_month fm on fm.form_month_id = ped.form_month_id
           where form_code = 'P'
         )
         select  ('' || ray.agency_id || ray.data_year)::int4 as yearly_agency_id,
         ray.agency_id,
         ray.data_year,
         ra.ori,
         ra.legacy_ori,
         acy.covered_by_legacy_ori,
         case when ray.is_direct_contributor then 'Y' else 'N' end as direct_contributor_flag,
         case when ray.agency_status = 'D' then 'Y' else 'N' end as dormant_flag,
         null::int2 dormant_year,
         case when ray.is_nibrs then 'I' else 'S' end as reporting_type,
         ra.ucr_agency_name,
         ra.ncic_agency_name,
         ra.pub_agency_name,
         ra.pub_agency_unit,
         ray.agency_status,
         st.state_id,
         st.name state_name,
         st.abbr state_abbr,
         st.postal_abbr state_postal_abbr,
         rd.code::int2 division_code,
         rd.name division_name,
         rr.code::int2 region_code,
         rr.name region_name,
         rr.description region_desc,
         t.name agency_type_name,
         ray.population,
         ra.submitting_agency_id,
         rsa.sai,
         rsa.agency_name submitting_agency_name,
         case when ray.is_suburban_area then 'Y' else 'N' end as suburban_area_flag,
         ray.population_group_id,
         rpg.code population_group_code,
         rpg.description population_group_desc,
         rppg.code parent_pop_group_code,
         rppg.description parent_pop_group_desc,
         case when ray.is_mip then 'Y' else 'N' end as mip_flag,
         rpg.sort_order pop_sort_order,
         null::text summary_rape_def,
         case when (ped.male_officer + ped.female_officer) > 0 then 'Y' else 'N'  end as pe_reported_flag,
         ped.male_officer pe_male_officer_count,
         ped.male_civilian pe_male_civilian_count,
         ped.male_officer + ped.male_civilian "male_officer+male_civilian",
         ped.female_officer pe_female_officer_count,
         ped.female_civilian pe_female_civilian_count,
         ped.female_officer + ped.female_civilian "female_officer+female_civilian",
         case when ray.population > 0 then round((ped.male_officer + ped.female_officer) / (ray.population::numeric / 1000), 1) else 0 end as officer_rate,
         case when ray.population > 0 then round((ped.male_officer + ped.female_officer + ped.male_civilian + ped.female_civilian) / (ray.population::numeric / 1000), 1) else 0  end as employee_rate,
         rsa.nibrs_cert_date,
         ra.nibrs_start_date,
         ra.nibrs_leoka_start_date,
         ra.nibrs_ct_start_date,
         ra.nibrs_multi_bias_start_date,
         ra.nibrs_off_eth_start_date,
         case when ray.is_covered then 'Y' else 'N'  end as covered_flag,
         (
           select string_agg(name, ';' order by name)
           from ref_agency_county ac
           join ref_county rc on ac.county_id = rc.county_id
           where ray.agency_id = ac.agency_id and ray.data_year = ac.data_year group by agency_id
         ) as county_name,
         (
          select string_agg(distinct rmm."name" , ';' order by rmm."name")
          from ref_metro_division rmd
          join ref_msa rmm using (msa_id)
          join ref_agency_county rac using (metro_div_id)
          where ray.agency_id = rac.agency_id and ray.data_year = rac.data_year group by agency_id
        ) as msa_name,
        (
          select string_agg(distinct rmd."name" , ';' order by rmd."name")
          from ref_metro_division rmd
          join ref_msa rmm using (msa_id)
          join ref_agency_county rac using (metro_div_id)
          where ray.agency_id = rac.agency_id and ray.data_year = rac.data_year group by agency_id
        ) as metro_division,
         case when ray.is_publishable then 'Y'  else 'N'  end as publishable_flag,
         CASE WHEN ry.months_yearly >= 1 then 'Y' else 'N' END as participated,
         CASE WHEN ray.is_covered = false and ny.months_yearly >= 1 then 'Y' else 'N' END as nibrs_participated,
         ra.judicial_district_code,
         rfo.numeric_code  as field_office
         from ref_agency ra
         join ref_submitting_agency rsa on ra.submitting_agency_id = rsa.agency_id
         join ref_agency_yearly ray on ra.agency_id = ray.agency_id
         join ref_agency_type t on ra.agency_type_id = t.agency_type_id
         join ref_state st on ra.state_id = st.state_id
         join ref_division rd on st.division_id = rd.division_id
         join ref_region rr on rd.region_id = rr.region_id
         left join ref_field_office rfo using (field_office_id)
         left join ref_population_group rpg on ray.population_group_id = rpg.population_group_id
         left join ref_parent_population_group rppg on rpg.parent_pop_group_id = rppg.parent_pop_group_id
         left join agency_covered_by_yearly acy on ray.agency_id = acy.agency_id and ray.data_year = acy.data_year
         left join pe_data ped on ray.agency_id = ped.agency_id and ray.data_year = ped.data_year
         left join reta_yearly ry on ray.agency_id = ry.agency_id and ray.data_year = ry.data_year
         left join nibrs_yearly ny on ray.agency_id = ny.agency_id and ray.data_year = ny.data_year
         WHERE ray.data_year = a_year order by ray.agency_id;
 
$function$
;
