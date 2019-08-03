.onAttach <- function(...) {
  packageStartupMessage("Attaching featuretoolsR with default options")

  # Check if we have a virtualenv available
  path <- paste(reticulate::virtualenv_root(), "featuretoolsR", sep = "/")
  if(!file.exists(path)) {
    packageStartupMessage("WARNING: No virtualenv found. Please run `install_featuretools()` to create one and setup featuretools.")
  } else {
    # Select virtualenv
    reticulate::use_virtualenv(getOption("featuretoolsR.virtualenv_name"))
  }

}

.onLoad <- function(...){
  reticulate::import("featuretools", delay_load = TRUE)
  options(
    featuretoolsR.force_posixct = TRUE,
    featuretoolsR.posixct_tz = "UTC",
    featuretoolsR.virtualenv_name = "featuretoolsR"
  )
}
