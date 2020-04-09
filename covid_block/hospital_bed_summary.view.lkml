#This view calculates thing like how many beds are available in different geopgrahies and estimates how many beds are being utilized


view: hospital_bed_summary {
  derived_table: {
    datagroup_trigger: covid_data
    #combining NYC fips codes to match other data
    sql:  SELECT *, case when fips in ( 36005, 36081, 36061, 36047, 36085 ) then 36125 else fips end as fipd
            FROM `lookerdata.covid19_block.hospital_bed_summary`
            WHERE hospital_type not in ('Rehabilitation Hospital', 'Psychiatric Hospital', 'Religious Non-Medical Health Care Institution') ;;
  }


####################
#### Original Dimensions ####
####################

  dimension: objectid {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.OBJECTID ;;
  }

  dimension: bed_utilization {
    hidden: yes
    type: number
    sql: ${TABLE}.BED_UTILIZATION ;;
  }

  dimension: cnty_fips {
    hidden: yes
    type: number
    sql: ${TABLE}.CNTY_FIPS ;;
  }

  dimension: county_name {
    hidden: yes
    type: string
    sql: ${TABLE}.COUNTY_NAME ;;
  }

  dimension: county_num_icu_beds {
    hidden: yes
    type: number
    sql: ${TABLE}.county_num_icu_beds ;;
  }

  dimension: county_num_licensed_beds {
    hidden: yes
    type: number
    sql: ${TABLE}.county_num_licensed_beds ;;
  }

  dimension: county_num_staffed_beds {
    hidden: yes
    type: number
    sql: ${TABLE}.county_num_staffed_beds ;;
  }

  dimension: fips {
    hidden: yes
    type: number
    sql: SUBSTR('00000' || IFNULL(SAFE_CAST(${TABLE}.fips AS STRING), ''), -5) ;;
  }

  dimension: hospital_name {
    group_label: "Hospital"
    type: string
    sql: ${TABLE}.HOSPITAL_NAME ;;
    link: {
      label: "{{ value }} - Hospital Deep Dive"
      url: "/dashboards/25?Hospital%20Name={{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
    action: {
      label: "Move ventilators over"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      icon_url: "https://sendgrid.com/favicon.ico"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "Move ventailors from {{ value }}"
      }
      form_param: {
        name: "To Mailing List"
        required: yes
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        "Given the high amount of risk seen in {{ value }}, we strongly recommend moving ventilators in."
      }
    }
  }

  dimension: hospital_type {
    group_label: "Hospital"
    type: string
    sql: ${TABLE}.HOSPITAL_TYPE ;;
  }

  dimension: hq_address {
    group_label: "Hospital"
    label: "Hospital Address"
    type: string
    sql: ${TABLE}.HQ_ADDRESS ;;
  }

  dimension: hq_address1 {
    hidden: yes
    type: string
    sql: ${TABLE}.HQ_ADDRESS1 ;;
  }

  dimension: hq_city {
    group_label: "Hospital"
    label: "Hospital City"
    type: string
    sql: ${TABLE}.HQ_CITY ;;
  }

  dimension: hq_state {
    hidden: yes
    type: string
    sql: ${TABLE}.HQ_STATE ;;
  }

  dimension: hq_zip_code {
    group_label: "Hospital"
    label: "Hospital Zip Code"
    value_format_name: id
    type: number
    sql: ${TABLE}.HQ_ZIP_CODE ;;
  }

  dimension: lat {
    hidden: yes
    type: number
    sql: ${TABLE}.Long ;;
  }

  dimension: long {
    hidden: yes
    type: number
    sql: ${TABLE}.Lat ;;
  }

  dimension: hospital_location {
    group_label: "Hospital"
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${long} ;;
  }

  dimension: num_icu_beds {
    hidden: yes
    type: number
    sql: ${TABLE}.NUM_ICU_BEDS ;;
  }

  dimension: num_licensed_beds {
    hidden: yes
    type: number
    sql: ${TABLE}.NUM_LICENSED_BEDS ;;
  }

  dimension: num_staffed_beds {
    hidden: yes
    type: number
    sql: ${TABLE}.NUM_STAFFED_BEDS ;;
  }

  dimension: potential_increase_in_bed_capac {
    hidden: yes
    type: number
    sql: ${TABLE}.Potential_Increase_In_Bed_Capac ;;
  }

  dimension: state_fips {
    hidden: yes
    type: number
    sql: ${TABLE}.STATE_FIPS ;;
  }

  dimension: state_name {
    hidden: yes
    type: string
    sql: ${TABLE}.STATE_NAME ;;
  }

  dimension: estimated_percent_of_covid_cases_of_county_dim {
    hidden: yes
    type: number
    sql: 1.0*${num_licensed_beds}/nullif(${county_num_licensed_beds},0) ;;
  }

####################
#### Derived Dimensions ####
####################

  dimension: num_icu_beds_available {
    hidden: yes
    type: number
    sql: ${num_icu_beds} * ${bed_utilization} ;;
  }

  dimension: num_staffed_beds_available {
    hidden: yes
    type: number
    sql: ${num_staffed_beds} * ${bed_utilization} ;;
  }

####################
#### Measures ####
####################

  measure: sum_num_icu_beds {
    group_label: "Hospital Capacity"
    label: "Count ICU Beds"
    type: sum
    sql: ${num_icu_beds} ;;
  }

  measure: sum_num_licensed_beds {
    group_label: "Hospital Capacity"
    label: "Count Licensed Beds"
    type: sum
    sql: ${num_licensed_beds} ;;
  }

  measure: sum_num_staffed_beds {
    group_label: "Hospital Capacity"
    label: "Count Staffed Beds"
    type: sum
    sql: ${num_staffed_beds} ;;
  }

  measure: sum_num_icu_beds_available {
    group_label: "Hospital Capacity"
    label: "Count ICU Beds Typically Available"
    type: sum
    sql: ${num_icu_beds_available} ;;
    value_format_name: decimal_0
  }

  measure: sum_num_staffed_beds_available {
    group_label: "Hospital Capacity"
    label: "Count Staffed Beds Typically Available"
    type: sum
    sql: ${num_staffed_beds_available} ;;
    value_format_name: decimal_0
  }

  measure: sum_county_num_licensed_beds {
    hidden: yes
    type: sum
    sql: ${county_num_licensed_beds} ;;
  }

  measure: force_1 {
    hidden: yes
    type: average
    sql: 1 ;;
  }

  measure: estimated_percent_of_covid_cases_of_county {
    hidden: yes
    type: number
    sql:
      {% if
                hospital_bed_summary.hospital_name._in_query
            or  hospital_bed_summary.hospital_type._in_query
            or  hospital_bed_summary.hospital_location._in_query
      %} 1.0*${sum_num_licensed_beds}/nullif(${sum_county_num_licensed_beds},0)
      {% else %}  ${force_1}
      {% endif %} ;;
    value_format_name: percent_1
  }

}
