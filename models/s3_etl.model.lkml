connection: "lookerdata"

include: "/S3_ETL/*.view.lkml"                # include all views in the views/ folder in this project

explore: us_counties {}
