#' Load features
#' @description Used to load previously saved features created during \link[featuretoolsR]{dfs}.
#' @export
#'
#' @param file The file containing the features.
#'
#' @examples
#' library(magrittr)
#'
#' # Create mock datasets
#' options(stringsAsFactors = TRUE)
#' set_1 <- data.frame(key = 1:100, value = sample(letters, 100, TRUE))
#' set_2 <- data.frame(key = 1:100, value = sample(LETTERS, 100, TRUE))
#' # Common variable: `key`
#' # Use dfs to create features
#' as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
#'   add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
#'   add_relationship(parent_set = "set_1", child_set = "set_2", idx = "key") %>%
#'   dfs(target_entity = "set_1", trans_primitives = c("and")) %>%
#'   extract_features() %>%
#'   save_features(filename = "some.features")
#'
#' # Load saves features
#' features <- load_features("some.features")
#'
load_features <- function(file = NA) {

  # Sanitize input
  if(is.na(file))
    stop("No file specified.")

  # Attempt to load file.
  return(
    .ft$load_features(
      normalizePath(file)
    )
  )

}



