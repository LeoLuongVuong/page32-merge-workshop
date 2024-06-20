# This script will copy a "demo model" into the main model directory and submit it.
# For example, model 199 is the full covariate model (106) from Expo 1
library(bbr)
library(here)
library(glue)

MOD_TO_COPY <- "199"

modDir <- here("model/pk")
demoDir <- here("model/demos")

fs::file_copy(glue("{demoDir}/{MOD_TO_COPY}.ctl"), modDir)
fs::file_copy(glue("{demoDir}/{MOD_TO_COPY}.yaml"), modDir)

mod <- read_model(file.path(modDir, MOD_TO_COPY))
submit_model(mod, .mode="local", .wait = TRUE)
