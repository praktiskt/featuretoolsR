#' List all available primitives.
#' @description List all available primitives from `featuretools` which can be passed to `dfs`.
#' @export
#'
#' @return A list of all primitives available.
#'
#' @examples
#' featuretoolsR::list_primitives()
list_primitives <- function() {
  ft <- reticulate::import("featuretools")
  ft$list_primitives()
}



