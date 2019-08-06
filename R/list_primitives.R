#' List all available primitives.
#' @description List all available primitives from `featuretools` which can be passed to \link[featuretoolsR]{dfs}.
#' @export
#'
#' @return A list of all primitives available.
#'
#' @examples
#' \donttest{
#' featuretoolsR::list_primitives()
#' }
list_primitives <- function() {
  .ft$list_primitives()
}



