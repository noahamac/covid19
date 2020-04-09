connection: "lookerdata"

include: "/covid_block/*.view.lkml"
include: "/census_data/*.view.lkml"



############ Census ############

explore: acs_zip_codes_2017_5yr {
  label: "ACS 2017 Data, By Zipcode"
  join: us_zipcode_boundaries {
    relationship: one_to_one
    sql_on: ${acs_zip_codes_2017_5yr.geo_id} = ${us_zipcode_boundaries.zip_code} ;;
  }
  join: zipcode_facts {
    relationship: one_to_one
    sql_on: ${zipcode_facts.us_zipcode_boundaries_zip_code}=${us_zipcode_boundaries.zip_code} ;;
  }
}

explore: acs_puma_2018 {
  group_label: "IN PROGRESS"
  label: "DRAFT: Census Data (PUMA Level)"

  join: zip_to_puma_v2 {
    relationship: many_to_many
    sql_on: ${acs_puma_2018.geo_id} = ${zip_to_puma_v2.puma} ;;
  }

#   join: us_zipcode_boundaries {
#     relationship: one_to_one
#     sql_on: ${zip_to_puma_v2.zcta5} = ${us_zipcode_boundaries.zip_code} ;;
#   }
#   join: zipcode_facts {
#     relationship: one_to_one
#     sql_on: ${zipcode_facts.us_zipcode_boundaries_zip_code}=${us_zipcode_boundaries.zip_code} ;;
#   }

}
