################################################################################
## Run Log Script
##
## * This file creates a run log in table format for evaluation of 
## key models of interest
##
## * NOTE: this repo does not have any pre-run models in it. Go to 
##  `script/model-management.Rmd` to create and run models, _before_ working
##  through this script.
##
################################################################################

library(bbr)
library(dplyr)
library(here)
library(magrittr)
library(tidyverse)
library(pmtables)
library(glue)

modDir <- here("model", "pk")
tabDir <- here("deliv", "table")
if(!file.exists(tabDir)) dir.create(tabDir)

THIS_SCRIPT = 'run-log.R'
options(pmtables.dir = tabDir)


# Define footnotes --------------------------------------------------------
## These are commonly used footnotes as examples - they can easily be customized
footnote_abbrev ="OFV = objective function value;\n
            Cond. no. = condition number."

##################################
# View ALL runs in designated model
# directory (modDir)
##################################

current_runs <- run_log(modDir) %>% 
  select(run, star, description, everything(), -absolute_model_path)
View(current_runs) # pops open window with basic bbr run log summary

# NOTE: if there are additional models in 'current_runs' you'd like 
# to add to the run log that are not yet starred, do that now using:
# mod <- read_model(modDir, 102)
# mod <- mod %>% add_star()

##################################
# Filter to "starred" runs
##################################
key_runs <- run_log(modDir) %>% filter(star==T) 
# View key run numbers to make sure all desired runs are included
key_runs$run

##################################
# Add desired information
##################################

# Pull OFV and Condition Number with add_summary()
runlog_df <- key_runs %>%
  add_summary() %>%
  select(run, description, ofv, condition_number)

##################################
# Generate run log table
##################################

# Basic formatting (rounding and column renaming)
runlog_df <- runlog_df %>%
  arrange(run) %>% 
  mutate(across(.cols = c(ofv:condition_number), ~round(.x))) %>% 
  select(
    Run=run, 
    Structure = description,
    OFV=ofv,
    `Cond no.` = condition_number
  )

# Create run log table with footnotes
runlog_tab <- runlog_df %>% 
  st_new() %>% 
  st_noteconf(type = "minipage", width = 1) %>% # option for formatting table
  stable(output_file = "model-run-log.png", # file name to be printed on table
         align = cols_align(Run=col_ragged(1), # use these to customize widths of cols
                            Structure=col_ragged(8),
                            OFV = col_ragged(1.5),
                            `Cond no.` = col_ragged(1.25)),
         r_file = THIS_SCRIPT, # prints source script on table image for traceability
         notes = c(footnote_abbrev)) %T>%  # customize additional footnotes here
  as_lscape() %T>% # make landscape
  st_aspng(dir=tabDir, stem = "model-run-log") # save out as .png

runlog_tab %>% st_as_image()
