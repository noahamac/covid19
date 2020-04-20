include: "acs_base_fields.view"
include: "//@{CONFIG_PROJECT_NAME}/census_data/acs_state_2018_1_yr.view.lkml"

view: acs_state_2018_1yr {
  extends: [acs_state_2018_1yr_config]
}

###################################################


view: acs_state_2018_1yr_core {
  sql_table_name: `bigquery-public-data.census_bureau_acs.state_2018_1yr`;;
  extends: [acs_base_fields]
  extension: required

  dimension: geo_id {
    label: "State"
  }

}
