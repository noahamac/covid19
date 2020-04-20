view: us_counties {
  sql_table_name: `bigquery-public-data.covid19_nyt.us_counties`
    ;;

  dimension: confirmed_cases {
    type: number
    sql: ${TABLE}.confirmed_cases ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: county_fips_code {
    type: string
    sql: ${TABLE}.county_fips_code ;;
  }

  dimension_group: date {
    type: time
    timeframes: [ date    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: deaths {
    type: number
    sql: ${TABLE}.deaths ;;
  }

  dimension: state_name {
    type: string
    sql: ${TABLE}.state_name ;;
  }

}
