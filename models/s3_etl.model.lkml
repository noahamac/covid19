connection: "@{CONNECTION_NAME}"

include: "/s3_etl/*.view.lkml"                # include all views in the views/ folder in this project

explore: us_counties {}
