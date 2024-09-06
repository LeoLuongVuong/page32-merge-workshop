################################################################################
## Model Parameter Table Script
## 
##
## * Creates report-ready parameter tables with transformed parameters specified
##  by yaml style parameter key.
##
## * Automatically generates '.png' and '.tex' files of formatted parameter tables 
##  and saves to 'deliv/table/model_name'.
##
## * NOTE: this repo does not have any pre-run models in it. Go to 
##  `script/model-management.Rmd` to create and run models, _before_ working
##  through this script.
################################################################################

### Packages ----------------------------
library(pmtables)
library(here)
library(bbr)
library(magrittr)
library(yaml)
library(pmparams)
library(glue)


### Model run ----------------------------
THIS_MODEL <- 199   # Covariate model

# NOTE: to run this script, you will need to do _either_
#
# * run the script model/demos/copy-demo-model.R to copy
#  and execute model 199, OR
#
# * set THIS_MODEL to one of the models you created in
#  `script/model-management.Rmd` and modify the parameter
#  key YAML file accordingly

### Directories ----------------------------
modDir <- here("model", "pk")                # define model directory
tabDir <- here("deliv", "table", THIS_MODEL)  # saves to subfolder with model name
if(!dir.exists(tabDir)) dir.create(tabDir)    # creates folder if it does not exist

# Set table options ------------------------
options(mrg.script = "parameter-table-final.R",   # name of this script
              pmtables.dir = tabDir) 

### Parameter key yaml file --------------
key <- here("script", "pk-parameter-key.yaml")  

# open parameter key in RStudio
# * check that it matches your model structure
# * make any necessary edits
file.edit(key)

# Read in base model and format output in dataframe ----------------------------
sum <- read_model(here(modDir, THIS_MODEL)) %>%   
  model_summary()  # shows quick model summary 

sum <- read_model("./model/pk/199") %>%   
  model_summary() 

# To see all raw model parameters
sum %>% param_estimates()

# Format parameter estimates
param_df <- sum %>% 
  define_param_table(.key = key) %>% 
  format_param_table(.prse = TRUE)

# Print parameter names, descriptions, etc. to review
View(param_df)

  
## Fixed effects only table ----------------------------
fixed = param_df %>% 
  make_pmtable(.pmtype = "fixed") %>%
  st_left(desc = col_ragged(4.5)) %>%
  st_notes(param_notes()$ci,           # add abbreviations
           param_notes()$rse,
           param_notes()$se) %>%   
  st_notes_str() %>%                # collapse all abbreviations to a string                        
  st_notes(param_notes()$logTrans,  # customize other notes
           param_notes()$ciEq       
           ) %>%
  st_files(output = glue("{THIS_MODEL}-pk-params-fixed.png")) %>%   # specify source file name to be printed in footnotes
  stable() %T>% 
  st_aspng(dir = tabDir, stem = glue("{THIS_MODEL}-pk-params-fixed")) # saves .png to tabDir

fixed %>% st_as_image() 

##  Random Effects table ------------------------------
random = param_df %>% 
  make_pmtable(.pmtype = "random") %>%
  st_notes(param_notes()$ci, param_notes()$corr,    # add abbreviations
           param_notes()$cv, param_notes()$rse,
           param_notes()$se) %>%   
  st_notes_str() %>%                # collapse all abbreviations to a string 
  st_notes(param_notes()$logTrans,  # customize other notes
           param_notes()$ciEq,      
           param_notes()$cvOmegaEq, 
           param_notes()$cvSigmaEq) %>%
  st_files(output = glue("{THIS_MODEL}-pk-params-random.png")) %>%   # specify source file name to be printed in footnotes
  stable() %T>%          
  st_aspng(dir = tabDir, stem = glue("{THIS_MODEL}-pk-params-random")) # saves .png to tabDir

random %>% st_as_image() 

