#' Install featuretools
#' @description A shortcut for installing `featuretools` with `pip`.
#' @export
#'
#' @examples
#' featuretoolsR::install_featuretools()
install_featuretools <- function() {

  virtualenv_name <- "featuretoolsR"
  path <- paste(reticulate::virtualenv_root(), virtualenv_name, sep = "/")
  if(!file.exists(path)) {
    reticulate::virtualenv_create(virtualenv_name)
  } else {
    message("Using existing virtualenv in ", path)
  }

  # Check if featuretools is installed
  ft_dir <- paste(path, "bin", "featuretools", sep = "/")
  if(!file.exists(ft_dir)) {
    message("Installing featuretools into ", path)
    # Install featuretools
    reticulate::virtualenv_install(virtualenv_name, packages = "featuretools")
  }

  # Use new virtualenv
  use_virtualenv(virtualenv_name)
}
