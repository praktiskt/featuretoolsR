#' Calculate feature matrix
#' @description This function is used to create a feature matrix based on a custom list of features (usually created from \link[featuretoolsR]{save_features}).
#' @export
#'
#' @param entityset The entityset on which to create features.
#' @param features The features to create based on previous runs of \link[featuretoolsR]{dfs}.
#' @param ... Additional parameters passed to `featuretoools.calculate_feature_matrix`.
#' @return A feature matrix
#'
#' @examples
#' es <- as_entityset(cars, index = "row_number")
#' calculate_feature_matrix(entityset = es, features = load_features("path_to_features"))
#'
calculate_feature_matrix <- function(
  entityset,
  features,
  ...
) {

  # Import featuretools
  ft <- reticulate::import("featuretools")

  # Run featuretools
  return(
    ft$calculate_feature_matrix(
      features = features,
      entityset = entityset,
      ...
    )
  )

}
