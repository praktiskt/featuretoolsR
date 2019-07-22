#' Tidy feature matrix
#' @description Used for tidying up ('R-ify') the feature matrix after deep feature synthethis (\link[featuretoolsR]{dfs}).
#' @export
#'
#' @param .data The featuretools-object returned from \link[featuretoolsR]{dfs}.
#' @param remove_nzv Remove near zero variance variables created from \link[featuretoolsR]{dfs}.
#' @param nan_is_na Turn all `NaN` into `NA`.
#' @param clean_names Make variable names R-friendly (snake case).
#' @return A tidy data.frame.
#'
#' @importFrom caret nearZeroVar
#' @importFrom purrr map
#' @importFrom tibble as.tibble
#'
#' @examples
#' library(magrittr)
#' options(stringsAsFactors = T)
#' set_1 <- data.frame(key = 1:100, value = sample(letters, 100, T))
#' set_2 <- data.frame(key = 1:100, value = sample(LETTERS, 100, T))
#' # Common variable: `key`
#'
#' as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
#'   add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
#'   add_relationship(set1 = "set_1", set2 = "set_2", idx = "key") %>%
#'   dfs(target_entity = "set_1", trans_primitives = c("and", "divide")) %>%
#'   tidy_feature_matrix(remove_nzv = T, nan_is_na = T)
tidy_feature_matrix <- function(
  .data,
  remove_nzv = F,
  nan_is_na = F,
  clean_names = F
) {

  # Coerce into R-object.
  to_r <- tibble::as.tibble(reticulate::py_to_r(.data[[1]]))

  # Variables get duplicated when coercing object from Python to R. Cleanup.
  nondupe <- to_r[, !duplicated(names(to_r))]

  # Process `nondupe` according to user defined parameters.
  ## Remove near zero variance
  if(remove_nzv) {
    cat("Removing near zero variance variables\n")
    nzvs <- purrr::map_dfr(
      lapply(
        X = names(nondupe),
        FUN = function(colname) {
          t <- caret::nearZeroVar(nondupe[, colname], saveMetrics = T)
          t$variable <- colname
          return(t)
        }
      ), c)

    # Update nondupe-set.
    nondupe <- nondupe[, !nzvs$nzv]
  }

  ## Replace all `NaN` with `NA`
  if(nan_is_na) {
    cat("Changing all `NaN` to `NA`\n")
    for (colname in names(nondupe)) {
      nondupe[, colname][[1]][is.nan(nondupe[, colname][[1]])] <- NA
    }
  }

  ## Make variable names more R-friendly
  if(clean_names) {
    cat("Creating R-friendly variable names\n")
    n <- tolower(names(nondupe))
    tn <- gsub("[^A-z0-9]", "_", n)
    tn <- gsub("(_+?$)|(__+?)", "", tn)
    names(nondupe) <- tn
  }

  # Back to data.frame
  result <- as.data.frame(nondupe)

  return(result)

}
