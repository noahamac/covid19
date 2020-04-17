connection: "lookerdata"

#views
include: "/covid_block/*.view.lkml"


#map layers
include: "map_layers.lkml"


############ For the block ############

### Main Covid Explore ######

explore: covid_combined {
  description: "This explore has the core metrics for the COVID19 datasets, international data is available at the state level through JHU and county level data is available for the United States through NYT"
  group_label: "*COVID 19"
  label: "COVID - Main"
  view_label: " COVID19"

## Testing Data by State (US Only) ##

  join: state_region {
    view_label: " COVID19"
    relationship: many_to_one
    sql_on: ${covid_combined.province_state} = ${state_region.state} ;;
  }

  join: covid_tracking_project {
    view_label: " COVID19"
    relationship: many_to_one
    sql_on:
          ${state_region.state_code} = ${covid_tracking_project.state_code}
      AND ${covid_combined.measurement_raw} = ${covid_tracking_project.measurement_raw}
    ;;
  }

## Hospital Bed Data ##

  join: hospital_bed_summary {
    view_label: " COVID19"
    relationship: many_to_many
    sql_on: ${covid_combined.fips} = ${hospital_bed_summary.fips} ;;
  }

## State Policy Reactions ##

  join: policies_by_state {
    view_label: "State Policy"
    relationship: many_to_one
    sql_on: ${covid_combined.province_state} = ${policies_by_state.state} ;;
  }

## Max Date for Running Total Logic ##

  join: max_date_covid {
    relationship: one_to_one
    sql_on: 1 = 1  ;;
  }

  join: max_date_tracking_project {
    relationship: one_to_one
    sql_on: 1 = 1  ;;
  }

## Rank ##

  join: country_rank {
    fields: []
    relationship: many_to_one
    sql_on: ${covid_combined.country_raw} = ${country_rank.country_raw} ;;
  }

  join: state_rank {
    fields: []
    relationship: many_to_one
    sql_on: ${covid_combined.province_state} = ${state_rank.province_state} ;;
  }

  join: fips_rank {
    fields: []
    relationship: many_to_one
    sql_on: ${covid_combined.fips} = ${fips_rank.fips} ;;
  }

## Growth Rate / Days to Double ##

  join: prior_days_cases_covid {
    view_label: " COVID19"
    relationship: one_to_one
    sql_on:
        ${covid_combined.measurement_date} = ${prior_days_cases_covid.measurement_date}
    AND ${covid_combined.pre_pk} = ${prior_days_cases_covid.pre_pk};;
  }

## Add in state & country region & population ##

  join: population_by_county_state_country {
    view_label: "Vulnerable Populations"
    relationship: many_to_one
    sql_on: ${covid_combined.pre_pk} = ${population_by_county_state_country.pre_pk} ;;
  }

  join: country_region {
    view_label: " COVID19"
    relationship: many_to_one
    sql_on: ${covid_combined.country_region} = ${country_region.country} ;;
  }
}

#### Compare Geographies ####

explore: kpis_by_entity_by_date {
  description: "This is a simplified explore, based only on JHU / NYT data, that can be used to compare different geographies with each other"
  group_label: "*COVID 19"
  label: "COVID Apps - Compare Geographies"
  view_label: " COVID19"
  sql_always_where:
          {% if kpis_by_entity_by_date.days_since_first_outbreaks._in_query %} ${days_since_first_outbreaks} > 0
          {% else %}  1 = 1
          {% endif %}
  ;;
}

#### Italy ####

explore: italy {
  description: "This explore is based off of data released from the Italian government which shows province and region level data for Italy"
  group_label: "*COVID 19"
  from: italy_regions

  join: italy_province {
    relationship: one_to_many
    view_label: "Italy"
    sql_on: ${italy.pk} = ${italy_province.region_fk};;
  }

  join: max_italy_date {
    relationship: one_to_one
    sql_on:  1 = 1 ;;
  }

  join: italy_region_stats {
    relationship: many_to_one
    sql_on: (${italy.region_code} = ${italy_region_stats.codice_regione} OR ${italy_region_stats.codice_regione} = 4)
              AND ${italy.region_name} = ${italy_region_stats.denominazione_regione} ;;
  }

  join: italy_province_stats {
    relationship: many_to_one
    sql_on: ${italy_province.province_abbreviation} = ${italy_province_stats.sigla_provincia} ;;
  }
}

############ Caching Logic ############

persist_with: covid_data

### PDT Timeframes

datagroup: covid_data {
  max_cache_age: "12 hours"
  sql_trigger:
    SELECT min(max_date) as max_date
    FROM
    (
      SELECT max(cast(date as date)) as max_date FROM `bigquery-public-data.covid19_nyt.us_counties`
      UNION ALL
      SELECT max(cast(date as date)) as max_date FROM `bigquery-public-data.covid19_jhu_csse.summary`
    ) a
  ;;
}
