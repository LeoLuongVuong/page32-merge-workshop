library(bbr)

#' Add AIC to Run Log data frame
add_aic <- function(.runlog) {
  ## check summary log appended
  if(any(str_detect(names(.runlog), "param_count")) & 
     any(str_detect(names(.runlog), "ofv"))) {
    return(mutate(.runlog, aic=2*param_count + ofv))
  }
  ## if not, return unchanged
  warning("AIC could not be computed")
  return(.runlog)
}

#' Compare ofv to that of the model in based_on
#' If multiple models are in based_on, use the first
add_dofv <- function(.runlog) {
  .runlog %>%
    mutate(based_on_join = purrr::map_chr(based_on, function(x) {ifelse(length(x) > 0, x[1], NA)})) %>% 
    left_join(
      select(.runlog, based_on_join=run, based_on_ofv=ofv), 
      by="based_on_join"
    ) %>% 
    mutate(dofv = as.numeric(format(ofv - based_on_ofv, nsmall = 2))) %>% 
    select(-based_on_ofv, -based_on_join)
}


#' Check if a given file exists in the model output directory
#' and open it in RStudio if it does. This is useful for files
#' like OUTPUT and PRDERR that may not be present.
open_file_if_exists <- function(.mod, .file) {
  .path <- file.path(get_output_dir(.mod), .file) 
  if (fs::file_exists(.path)) {
    file.edit(.path)
  } else {
    print(paste(
      fs::path_rel(.path, here::here()), 
      "does not exist. This may mean the model has finished running, or this file was not produced."
    ))
  }
}
