#' Install featuretools
#' @description Setup for featuretools in it's own virtualenv.
#' @export
#'
#' @examples
#' featuretoolsR::install_featuretools()
install_featuretools <- function() {

  virtualenv_name <- getOption("featuretoolsR.virtualenv_name")
  path <- paste(reticulate::virtualenv_root(), virtualenv_name, sep = "/")
  if(!file.exists(path)) {
    reticulate::virtualenv_create(virtualenv_name)
  } else {
    message("Using existing virtualenv in ", path)
  }

  # Check if featuretools is installed
  if(!reticulate::py_module_available("featuretools")) {
    message("Installing featuretools into ", path)
    # Install featuretools
    reticulate::virtualenv_install(virtualenv_name, packages = "featuretools")
  }

  # Use new virtualenv
  reticulate::use_virtualenv(virtualenv_name)
}
