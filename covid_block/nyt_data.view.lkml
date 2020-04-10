### This view contains the NYT county level data, coming from this source https://github.com/nytimes/covid-19-data

view: nyt_data {
  derived_table: {
    sql: select * except(county, fips),
           case when county = 'Unknown' then concat(county,' - ',state) else county end as county,
            case when county = 'Unknown'then NULL
                when county = 'New York City' then 36125
                when county = 'Kansas City' then 29095
                else fips end as fips
        from `lookerdata.covid19_block.nyt_data`;;
    sql_trigger_value: SELECT COUNT(*) FROM `lookerdata.covid19_block.nyt_data`;;
  }

}
