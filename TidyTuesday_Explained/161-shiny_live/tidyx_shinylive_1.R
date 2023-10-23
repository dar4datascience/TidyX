

## the cars folder contains last weeks shiny app (bit.ly/TidyX_Ep160)
# # Delete prior
unlink("TidyTuesday_Explained/161-shiny_live/tidyx_apps", recursive = TRUE)

## Convert your shiny app into all the assets for running the app 
## in the browser
shinylive::export(
  appdir = "TidyTuesday_Explained/161-shiny_live/cars",
  destdir = "TidyTuesday_Explained/161-shiny_live/tidyx_apps"
  )


## with development version of httpuv, run shinylive app locally
#remotes::install_github("rstudio/httpuv")
httpuv::runStaticServer(dir = "TidyTuesday_Explained/161-shiny_live/tidyx_apps", port = 8888)

# WHY DOESNT PLUMBER WORK?
#library(plumber)
# 

# Host the local directory
# pr() |> 
#   pr_static("/", "TidyTuesday_Explained/161-shiny_live/tidyx_apps/index.html") |> 
#   pr_run()


# Config for github pages deployment
shinylive::export(
  appdir = "TidyTuesday_Explained/161-shiny_live/cars",
  destdir = "docs"
)
