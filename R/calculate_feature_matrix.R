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
#' \donttest{
#' library(magrittr)
#'
#' # Create some mock data
#' set_1 <- data.frame(key = 1:100, value = sample(letters, 100, TRUE), stringsAsFactors = TRUE)
#' set_2 <- data.frame(key = 1:100, value = sample(LETTERS, 100, TRUE), stringsAsFactors = TRUE)
#' # Common variable: `key`
#'
#' # Create features and save them
#' as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
#'   add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
#'   add_relationship(
#'     parent_set = "set_1",
#'     child_set = "set_2",
#'     parent_idx = "key",
#'     child_idx = "key"
#'   ) %>%
#'   dfs(target_entity = "set_1", trans_primitives = c("and")) %>%
#'   extract_features() %>%
#'   save_features(filename = "some.features")
#'
#' # Re-create entityset, but rather than dfs use calcualte_feature_matrix.
#' es <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
#'   add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
#'   add_relationship(
#'     parent_set = "set_1",
#'     child_set = "set_2",
#'     parent_idx = "key",
#'     child_idx = "key"
#'   )
#' calculate_feature_matrix(entityset = es, features = load_features("some.features"))
#' }
calculate_feature_matrix <- function(
  entityset,
  features,
  ...
) {
  # Run featuretools
  return(
    .ft$calculate_feature_matrix(
      features = features,
      entityset = entityset,
      ...
    )
  )

}
