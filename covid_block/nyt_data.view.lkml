### This view contains the NYT county level data, coming from BQ public datasets

view: nyt_data {
  derived_table: {
    sql: select * except(county, fips),
           case when county = 'Unknown' then concat(county,' - ',state) else county end as county,
            case when county = 'Unknown'then NULL
                --mofifying the FIPS code to match other data
                when county = 'New York City' then 36125
                when county = 'Kansas City' then 29095
                else fips end as fips
        from `lookerdata.covid19_block.nyt_data`;;
    sql_trigger_value: SELECT COUNT(*) FROM `bigquery-public-data.covid19_nyt.us_counties` ;;
  }

}
