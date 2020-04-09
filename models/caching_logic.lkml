############ Caching Logic ############

persist_with: covid_data

### PDT Timeframes

datagroup: covid_data {
  max_cache_age: "12 hours"
  sql_trigger:
    SELECT min(max_date) as max_date
    FROM
    (
      SELECT max(cast(date as date)) as max_date FROM `lookerdata.covid19.nyt_covid_data`
      UNION ALL
      SELECT max(cast(date as date)) as max_date FROM `bigquery-public-data.covid19_jhu_csse.summary`
    ) a
  ;;
}

datagroup: jhu_data {
  max_cache_age: "12 hours"
  sql_trigger: SELECT count(*) FROM `bigquery-public-data.covid19_jhu_csse.summary` ;;
}

datagroup: once_daily {
  max_cache_age: "24 hours"
  sql_trigger: SELECT current_date() ;;
}

datagroup: once_weekly {
  max_cache_age: "168 hours"
  sql_trigger: SELECT extract(week from current_date()) ;;
}

datagroup: once_monthly {
  max_cache_age: "720 hours"
  sql_trigger: SELECT extract(month from current_date()) ;;
}

datagroup: once_yearly {
  max_cache_age: "9000 hours"
  sql_trigger: SELECT extract(year from current_date()) ;;
}
