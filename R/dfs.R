#' Deep Feature Synthesis
#' @description The main function from featuretools used to create new features.
#' @export
#'
#' @param entityset The entityset on which to perform dfs.
#' @param target_entity The name of the entity on which to perform dfs.
#' @param agg_primitives Primitives passed to relational data.
#' @param trans_primitives Primitives passed to non-relational data.
#' @param ... Additional parameters passed to `featuretools.dfs`.
#' @return A `featuretools` feature matrix.
#'
#' @examples
#' es <- as_entityset(cars, index = "row_number")
#' dfs(es, target_entity = "df1", trans_primitives = c("and", "divide"))
dfs <- function(entityset,
                target_entity,
                agg_primitives = NULL,
                trans_primitives = NULL,
                max_depth = 2L,
                ...) {

  # Load featuretools
  ft <- reticulate::import("featuretools")

  feature_matrix <- ft$dfs(
    entityset = entityset,
    target_entity = target_entity,
    agg_primitives = reticulate::r_to_py(agg_primitives),
    trans_primitives = reticulate::r_to_py(trans_primitives),
    max_depth = max_depth,
    ...
  )

  return(feature_matrix)
}



