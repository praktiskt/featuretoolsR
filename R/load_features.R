#' Load features
#' @description Used to load previously saved features created during `dfs`.
#' @export
#'
#' @param file The file containing the features.
#'
#' @examples
#' # Use dfs to create features
#' as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
#'   add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
#'   add_relationship(set1 = "set_1", set2 = "set_2", idx = "key") %>%
#'   dfs(target_entity = "set_1", trans_primitives = c("and", "divide")) %>%
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

  # Load featuretools
  ft <- reticulate::import("featuretools")

  # Attempt to load file.
  return(
    ft$load_features(
      filepath = file
    )
  )

}



