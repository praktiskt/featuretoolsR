#' Deep Feature Synthesis
#' @description The main function from featuretools used to create new features.
#' @export
#'
#' @param entityset The entityset on which to perform dfs.
#' @param target_entity The name of the entity on which to perform dfs.
#' @param agg_primitives Primitives passed to relational data.
#' @param trans_primitives Primitives passed to non-relational data.
#' @param max_depth Controls the maximum depth of features.
#' @param ... Additional parameters passed to `featuretools.dfs`.
#' @return A `featuretools` feature matrix.
#'
#' @examples
#' \donttest{
#' es <- as_entityset(cars, index = "row_number")
#' dfs(es, target_entity = "df1", trans_primitives = c("and"))
#' }
dfs <- function(
  entityset,
  target_entity,
  agg_primitives = NULL,
  trans_primitives = NULL,
  max_depth = 2L,
  ...
) {
  # Ensure primitives are in the correct format
  if(!is.list(agg_primitives)) {
    agg_primitives <- as.list(agg_primitives)
  }
  if(!is.list(trans_primitives)) {
    trans_primitives <- as.list(trans_primitives)
  }

  # Ensure primitives are valid
  aggs <- list_primitives()[list_primitives()$type=="aggregation", "name"]
  .agg_primitives <- unlist(agg_primitives)
  if(any(!(.agg_primitives %in% aggs))) {
    invalid <- paste0(.agg_primitives[!(.agg_primitives %in% aggs)], collapse = "`, `")
    stop("Invalid aggregate primitive(s): `", invalid, "`. Use list_primitives() to find valid primitives.")
  }

  trans <- list_primitives()[list_primitives()$type=="transform", "name"]
  .trans_primitives <- unlist(trans_primitives)
  if(any(!(.trans_primitives %in% trans))) {
    invalid <- paste0(.trans_primitives[!(.trans_primitives %in% trans)], collapse = "`, `")
    stop("Invalid transform primitive(s): `", invalid, "`. Use list_primitives() to find valid primitives.")
  }

  # DFS
  feature_matrix <- .ft$dfs(
    entityset = entityset,
    target_entity = target_entity,
    agg_primitives = reticulate::r_to_py(agg_primitives),
    trans_primitives = reticulate::r_to_py(trans_primitives),
    max_depth = max_depth,
    ...
  )

  return(feature_matrix)
}



