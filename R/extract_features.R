#' Extract features
#' @description This function is used to extract all features created from \link[featuretoolsR]{dfs}.
#' @export
#'
#' @param .data The featuretools-object returned from \link[featuretoolsR]{dfs}.
#' @return All features created during \link[featuretoolsR]{dfs}, as a tibble.
#'
#' @importFrom tibble tibble
#' @importFrom purrr map
#'
#' @examples
#' \donttest{
#' library(magrittr)
#' set_1 <- data.frame(key = 1:100, value = sample(letters, 100, TRUE), stringsAsFactors = TRUE)
#' set_2 <- data.frame(key = 1:100, value = sample(LETTERS, 100, TRUE), stringsAsFactors = TRUE)
#' # Common variable: `key`
#'
#' as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
#'   add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
#'   add_relationship(
#'     parent_set = "set_1",
#'     child_set = "set_2",
#'     parent_idx = "key",
#'     child_idx = "key"
#'   ) %>%
#'   dfs(target_entity = "set_1", trans_primitives = c("and")) %>%
#'   extract_features()
#' }
extract_features <- function(.data) {

  # List features in ft-object
  feature_names <- unlist(purrr::map(
    .data[[2]],
    .f = function(feature) {
      feature$get_name()
    }
  ))

  # Extract features
  feature_actuals <- purrr::map(
    .data[[2]],
    .f = function(feature) {
      feature
    }
  )

  # Construct informative tibble with features
  return(
    tibble::tibble(
      name = feature_names,
      feature = feature_actuals
    )
  )
}
