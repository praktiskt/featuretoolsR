#' Create entityset
#' @description Create a blank entityset. A shortcut for `featuretools'` `EntitySet`.
#' @export
#'
#' @param id The id of this entityset.
#' @return An entityset.
#'
#' @examples
#' \donttest{
#' create_entityset(id = "my_entityset")
#' }
create_entityset <- function(id) {
  es <- .ft$EntitySet(id = id)
  return(es)
}
