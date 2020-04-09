# connection: "lookerdata"
#
# include: "/covid_block/*.view.lkml"
# include: "/census_data/*.view.lkml"
# include: "/intl_covid_data/*.view.lkml"
# include: "/us_covid_data/*.view.lkml"


############ OLD INTL ############

# explore: covid_data {
#   group_label: "OLD"
#
#   join: max_date_intl {
#     fields: []
#     relationship: one_to_one
#     sql_on: 1 = 1  ;;
#   }
#
# #   join: cases_by_country_by_date {
# #     # fields: []
# #     relationship: many_to_one
# #     sql_on:
# #           ${covid_data.country_raw} = ${cases_by_country_by_date.country_raw}
# #       AND ${covid_data.date_raw} = ${cases_by_country_by_date.date_raw}
# #       ;;
# #   }
# #
# #   join: days_since_first_case_country {
# #     fields: []
# #     relationship: many_to_one
# #     sql_on: ${covid_data.country_raw} = ${days_since_first_case_country.country_raw} ;;
# #   }
# #
# #   join: days_since_first_case_state {
# #     fields: []
# #     relationship: many_to_one
# #     sql_on: ${covid_data.state} = ${days_since_first_case_state.state} ;;
# #   }
#
#   join: prior_days_cases {
#     relationship: one_to_one
#     type: inner
#     sql_on: ${prior_days_cases.country_raw} = ${covid_data.country_raw}
#       AND ${prior_days_cases.state} = ${covid_data.state}
#       AND ${prior_days_cases.date_date} = ${covid_data.date_date}
#     ;;
#   }
# }



############ OLD US ############

# explore: tests_by_state {
#   group_label: "OLD"
#
#   join: max_date_us {
#     fields: []
#     relationship: one_to_one
#     sql_on: 1 = 1  ;;
#   }
#
#   join: acs_puma_state_facts {
#     relationship: many_to_one
#     sql_on: ${tests_by_state.state} = ${acs_puma_state_facts.state_abbreviation} ;;
#   }
#
# }
