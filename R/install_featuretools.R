#' Install featuretools
#' @description A shortcut for installing `featuretools` with `pip`.
#' @export
#'
#' @examples
#' featuretoolsR::install_featuretools()
install_featuretools <- function() {
  system(command = "pip install featuretools")
}
