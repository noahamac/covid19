### This view contains the NYT county level data, coming from this source https://github.com/nytimes/covid-19-data

view: nyt_data {
  derived_table: {
    sql: select * from `lookerdata.covid19_block.nyt_data`;;
    sql_trigger_value: SELECT COUNT(*) FROM `lookerdata.covid19_block.nyt_data`;;
  }

  dimension: cases {
    type: number
    sql: ${TABLE}.cases ;;
  }

  dimension: county {
    type: string
    #if the county is unknown, make the county = 'Unknown-State'
    sql: case when ${TABLE}.county = 'Unknown' then concat(${TABLE}.county,' - ',${TABLE}.state) else ${TABLE}.county end;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: deaths {
    type: number
    sql: ${TABLE}.deaths ;;
  }

  dimension: fips {
    type: number
    #correcting some fips from the NYT data
    sql: case when ${TABLE}.county = 'Unknown'then NULL
              when ${TABLE}.county = 'New York City' then 36125
              when ${TABLE}.county = 'Kansas City' then 29095
              else ${TABLE}.fips end;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }
}
