project_name: "covid"

################ Constants ################

constant: CONFIG_PROJECT_NAME {
  value: "data-block-covid19-config"
  export: override_required
}

constant: CONNECTION_NAME {
  value: "lookerdata"
  export: override_required
}

constant: DATASET_NAME {
  value: "covid19_block"
  export: override_required
}

constant: mapbox_api_key {
  value: "pk.eyJ1IjoibG9va2VyLW1hcHMiLCJhIjoiY2sxODBsbnBiMWx1aDNndGpieGtxN2p3NiJ9.hmqB9XRdFX29m1U6sOffLw"
}


################ Dependencies ################

local_dependency: {
  project: "@{CONFIG_PROJECT_NAME}"
}
