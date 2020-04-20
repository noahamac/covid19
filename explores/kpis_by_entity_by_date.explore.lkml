#### Compare Geographies ####

explore: kpis_by_entity_by_date_core {
  from: kpis_by_entity_by_date
  extension: required
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

explore: italy_core {
  from: italy_regions
  extension: required
  description: "This explore is based off of data released from the Italian government which shows province and region level data for Italy"
  group_label: "*COVID 19"


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
