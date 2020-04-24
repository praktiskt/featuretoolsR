#' Install featuretools
#' @description Setup for featuretools in it's own virtualenv, or into the default reticulate virtualenv.
#'
#' @param custom_virtualenv Set to true if you wish to use a custom virtualenv for featuretoolsR.
#' @param method The installation method passed to \link[reticulate]{py_install}. Defaults to "auto".
#' @param conda Whether to use conda or not. Passed to \link[reticulate]{py_install}. Defaults to "auto".
#' @export
#'
#' @examples
#' \dontrun{
#' featuretoolsR::install_featuretools()
#' }
install_featuretools <- function(custom_virtualenv = FALSE, method = "auto", conda = "auto") {

  # See if conda, pip or pip3 is installed.
  status <- list(
    conda = cli_is_installed("conda"),
    pip = cli_is_installed("pip"),
    pip3 = cli_is_installed("pip3")
  )

  if(!any(status == TRUE)) {
    stop("Neither `pip`, `pip3` or `conda` was found. At least one is required to install Featuretools.")
  }

  # Installation
  if(custom_virtualenv) {
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
  } else {
    reticulate::py_install("featuretools", method = method, conda = conda)
  }

  # Reload library
  unloadNamespace("featuretoolsR")
  rstudioapi::restartSession("library(featuretoolsR)")
}

cli_is_installed <- function(command) {
  tryCatch(expr = {
    system(command, intern = T, ignore.stderr = T)
    return(TRUE)
  }, error = function(e) {
    return(FALSE)
  })
}
