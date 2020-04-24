.onAttach <- function(...) {

  start <- paste("featuretoolsR", utils::packageVersion("featuretoolsR"))
  packageStartupMessage(cli::cat_boxx(start, padding = c(0, 3, 0, 3), border_style = "double"), appendLF = FALSE)

  if(!reticulate::py_module_available("pip")) {
    m <- "pip is not installed. Please install pip to proceed."
    msg <- cli::cat_bullet(m, bullet = "cross", bullet_col = "red")
  } else {
    # See if featuretools already is installed
    if(!reticulate::py_module_available("featuretools")) {
      msg <- cli::cat_bullet("Featuretools unavailable. Please run `install_featuretools()`, or install featuretools with pip.", bullet = "cross", bullet_col = "red")
    } else {
      # Display featuretools info
      ft <- paste("Using Featuretools", reticulate::py_get_attr(.ft, "__version__"))
      msg <- cli::cat_bullet(ft, bullet = "tick", bullet_col = "green")
    }
  }

  packageStartupMessage(msg)

}

.ft <- NULL
.onLoad <- function(...){
  .ft <<- reticulate::import("featuretools", delay_load = TRUE)
  options(
    featuretoolsR.force_posixct = TRUE,
    featuretoolsR.posixct_tz = "UTC",
    featuretoolsR.virtualenv_name = "featuretoolsR"
  )
}
