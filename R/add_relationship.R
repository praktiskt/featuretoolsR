#' Add a relationship to an entityset
#' @description Add a relationship to an entityset.
#' @export
#'
#' @param entityset The entityset to modify.
#' @param set1 The name of the first entity to link.
#' @param set2 The name of the second entity to link.
#' @param idx The variable  `set1` and `set2` have in common.
#' @return A modified entityset.
#'
#' @examples
#' library(magrittr)
#' options(stringsAsFactors = TRUE)
#' set_1 <- data.frame(key = 1:100, value = sample(letters, 100, TRUE))
#' set_2 <- data.frame(key = 1:100, value = sample(LETTERS, 100, TRUE))
#' # Common variable: `key`
#'
#' as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
#'   add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
#'   add_relationship(set1 = "set_1", set2 = "set_2", idx = "key")
add_relationship <- function(
  entityset,
  set1,
  set2,
  idx
) {
  # Find indexes for entites and variables inside entitysets
  es_names <- purrr::map_dfr(lapply(
    X = 1:length(entityset$entities),
    FUN = function(set) {
      variables <- unlist(lapply(
        X = entityset$entities[[set]]$variables,
        FUN = function(x) x$id
      ))

      t <- data.frame("variable_name" = variables, stringsAsFactors = FALSE)
      t$variable_idx <- 1:nrow(t)
      t$entity_name <- names(entityset$entity_dict)[[set]]
      t$entity_idx <- set

      return(t)

    }
  ), c)

  entity_set1_pos <- es_names$entity_idx[es_names$entity_name == set1][[1]]
  entity_set2_pos <- es_names$entity_idx[es_names$entity_name == set2][[1]]
  index_set1_pos <- es_names$variable_idx[es_names$variable_name == idx & es_names$entity_name == set1]
  index_set2_pos <- es_names$variable_idx[es_names$variable_name == idx & es_names$entity_name == set2]

  if (length(index_set1_pos) == 0 || length(index_set2_pos) == 0) {
    stop("Couldn't find index column `", idx, "` in `", set1, "` or `", set2, "`")
  }

  # Construct new relationship
  rel <- .ft$Relationship(
    entityset$entities[[entity_set1_pos]]$variables[[index_set1_pos]],
    entityset$entities[[entity_set2_pos]]$variables[[index_set2_pos]]
  )

  # Add relationship to entityset
  entityset <- entityset$add_relationship(rel)

  return(entityset)
}
