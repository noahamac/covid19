include: "/covid_block/covid_combined.view.lkml"


view: covid_combined_puma {
  extends: [covid_combined]

########################################
## County to PUMA Measure Conversion ###
########################################

  dimension: puma_conversion_factor {
    hidden: yes
    description: "Convert county to PUMA by population distribution"
    type: number
    sql: {% if puma_to_county_mapping_nyc_combined.puma_fips._in_query %}
          ${puma_to_county_mapping_nyc_combined.pct_of_county_pop_in_puma}
      {% else %} 1.0 {% endif %};;
  }

#   dimension: dymnamic_sql_distinct_key {
#     type: string
#     hidden: yes
#     description: "Dynamically detect if PUMA mapping table is used in query"
#     sql: ({% if puma_to_county_mapping_nyc_combined.puma_fips._in_query %}
#           concat(${pk},${puma_to_county_mapping_nyc_combined.puma_fips_raw})
#       {% else %} ${pk} {% endif %})  ;;
#   }

  ## confirmed cases ##

  measure: puma_confirmed_new_option_1 {
    description: "For zip to PUMA or County weighting"
    hidden: yes
    type: sum
    sql: ${covid_combined.confirmed_new_cases}*${puma_conversion_factor} ;;
    value_format_name: decimal_0
  }

  measure: puma_confirmed_new_option_2 {
    description: "For zip to PUMA or County weighting"
    hidden: yes
    type: sum
    sql: ${covid_combined.confirmed_new_cases}*${puma_conversion_factor} ;;
    filters: {
      field: covid_combined.is_max_date
      value: "Yes"
    }
    value_format_name: decimal_0
  }

  measure: puma_confirmed_new {
    group_label: "Measures by Public Use Microdata Area (PUMA)"
    label: "PUMA - Confirmed Cases (New)"
    value_format_name: decimal_0
    type: number
    sql:
          {% if covid_combined.measurement_date._in_query or covid_combined.days_since_first_outbreak._in_query or covid_combined.days_since_max_date._in_query %} ${puma_confirmed_new_option_1}
          {% else %}  ${puma_confirmed_new_option_2}
          {% endif %} ;;
    drill_fields: [covid_combined.drill*]
    link: {
      label: "Data Source - NYT County Data"
      url: "https://github.com/nytimes/covid-19-data"
      icon_url: "http://www.google.com/s2/favicons?domain_url=http://www.nytimes.com"
    }
    link: {
      label: "Data Source - Johns Hopkins State & Country Data"
      url: "https://github.com/CSSEGISandData/COVID-19"
      icon_url: "http://www.google.com/s2/favicons?domain_url=http://www.jhu.edu"
    }
    link: {
      label: "Data Source - Census to PUMA Crosswalk"
      url: "https://www2.census.gov/geo/docs/maps-data/data/rel/zcta_county_rel_10.txt"
      icon_url: "http://www.google.com/s2/favicons?domain_url=https://www2.census.gov"
    }
  }

  measure: puma_confirmed_option_1 {
    hidden: yes
    type: sum
    sql: ${covid_combined.confirmed_cumulative}*${puma_conversion_factor} ;;
    value_format_name: decimal_0
  }

  measure: puma_confirmed_option_2 {
    hidden: yes
    type: sum
    sql: ${covid_combined.confirmed_cumulative}*${puma_conversion_factor} ;;
    filters: {
      field: covid_combined.is_max_date
      value: "Yes"
    }
    value_format_name: decimal_0
  }

  measure: puma_confirmed_running_total {
    group_label: "Measures by Public Use Microdata Area (PUMA)"
    label: "PUMA - Confirmed Cases (Running Total)"
    value_format_name: decimal_0
    type: number
    sql:
          {% if covid_combined.measurement_date._in_query or covid_combined.days_since_first_outbreak._in_query or covid_combined.days_since_max_date._in_query %} ${puma_confirmed_option_1}
          {% else %}  ${puma_confirmed_option_2}
          {% endif %} ;;
    drill_fields: [covid_combined.drill*]
    link: {
      label: "Data Source - NYT County Data"
      url: "https://github.com/nytimes/covid-19-data"
      icon_url: "http://www.google.com/s2/favicons?domain_url=http://www.nytimes.com"
    }
    link: {
      label: "Data Source - Johns Hopkins State & Country Data"
      url: "https://github.com/CSSEGISandData/COVID-19"
      icon_url: "http://www.google.com/s2/favicons?domain_url=http://www.jhu.edu"
    }
    link: {
      label: "Data Source - Census to PUMA Crosswalk"
      url: "https://www2.census.gov/geo/docs/maps-data/data/rel/zcta_county_rel_10.txt"
      icon_url: "http://www.google.com/s2/favicons?domain_url=https://www2.census.gov"
    }
  }

 }
