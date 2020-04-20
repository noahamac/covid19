# include: "/census_data/*.view.lkml"
# include: "/covid_block/*.view.lkml"
# include: "covid.model.lkml"

connection: "@{CONNECTION_NAME}"

## Logic to map county data to PUMA level ##

#### We cant extend an explore with NDTs, so should we bring it into the block?

# explore: covid_combined_puma {
#   extends: [covid_combined]
#   join: puma_to_county_mapping_nyc_combined {
#     relationship: many_to_many
#     sql_on: ${covid_combined.fips_as_string} =  ${puma_to_county_mapping_nyc_combined.county_fips} ;;
#   }
#
#   join: acs_puma_facts {
#     view_label: "Vulnerable Populations"
#     relationship: many_to_one
#     sql_on: ${puma_to_county_mapping_nyc_combined.puma_fips} = ${acs_puma_facts.puma} ;;
#   }
# }


############ Census ############

# explore: acs_zip_codes_2017_5yr {
#   label: "ACS 2017 Data, By Zipcode"
#   join: us_zipcode_boundaries {
#     relationship: one_to_one
#     sql_on: ${acs_zip_codes_2017_5yr.geo_id} = ${us_zipcode_boundaries.zip_code} ;;
#   }
#   join: zipcode_facts {
#     relationship: one_to_one
#     sql_on: ${zipcode_facts.us_zipcode_boundaries_zip_code}=${us_zipcode_boundaries.zip_code} ;;
#   }
# }
#

# explore: acs_puma_2018 {
#   group_label: "IN PROGRESS"
#   label: "DRAFT: Census Data (PUMA Level)"
#
#   join: zip_to_puma_v2 {
#     relationship: many_to_many
#     sql_on: ${acs_puma_2018.geo_id} = ${zip_to_puma_v2.puma} ;;
#   }
#
#   join: us_zipcode_boundaries {
#     relationship: one_to_one
#     sql_on: ${zip_to_puma_v2.zcta5} = ${us_zipcode_boundaries.zip_code} ;;
#   }
#   join: zipcode_facts {
#     relationship: one_to_one
#     sql_on: ${zipcode_facts.us_zipcode_boundaries_zip_code}=${us_zipcode_boundaries.zip_code} ;;
#   }
#  }
