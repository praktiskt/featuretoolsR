#' Save features
#' @description Used to save all or a subset of features created during \link[featuretoolsR]{dfs}.
#' @export
#'
#' @importFrom stringr str_sub
#' @importFrom tibble is_tibble
#'
#' @param .data The tibble of features returned from \link[featuretoolsR]{extract_features}.
#' @param filename (optional) The name of the file to produce.
#' @param path (optional) The path where the feature file should be placed.
#'
#' @examples
#' \donttest{
#' library(magrittr)
#' set_1 <- data.frame(key = 1:100, value = sample(letters, 100, TRUE), stringsAsFactors = TRUE)
#' set_2 <- data.frame(key = 1:100, value = sample(LETTERS, 100, TRUE), stringsAsFactors = TRUE)
#' # Common variable: `key`
#'
#' dir <- tempdir()
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
#'   save_features(filename = "some.features", path = dir)
#' }
save_features <- function(
  .data,
  filename = NA,
  path = NA
) {

  # Sanitize input
  ## Input should be a tibble with 2 variables.
  if(any(c(colnames(.data) != c("name", "feature"), !tibble::is_tibble(.data))))
    stop("Bad input. Did you forget to use `extract_features`?")

  ## If user didn't set path, use working directory.
  ## (For featuretools' save_features, we need the full path)
  if(is.na(path)) {
    warning("No `path` set, defaulting to working directory\n")
    path <- paste0(normalizePath(getwd()), "/")
  } else {
    # Writer in Python requires full path, so fix user given path
    path <- paste0(normalizePath(path))

    # Make sure user entered path correctly
    if(stringr::str_sub(path, -1, -1) != "/")
      path <- paste0(path, "/")
  }

  ## If user didn't specify a file name, generate one.
  if(is.na(filename)) {
    tmp <- paste0(paste0(sample(c(letters, LETTERS), 16, FALSE), collapse = ""), ".features")
    warning("No `filename` passed, generated: ", tmp)
    path <- paste0(path, tmp)
  } else {
    path <- paste0(path, filename)
  }

  # Save all features passed from `extract_features`.
  .ft$save_features(
    features = .data$feature,
    location = path
  )

  return(TRUE)
}



