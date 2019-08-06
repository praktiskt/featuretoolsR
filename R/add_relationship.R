#' Add a relationship to an entityset
#' @description Add a relationship to an entityset.
#' @export
#'
#' @param entityset The entityset to modify.
#' @param parent_set The name of the parent set.
#' @param child_set The name of the child set.
#' @param parent_idx The index variable of the `parent_set`.
#' @param child_idx The index variable of the `child_set`.
#' @return A modified entityset.
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
#'   )
#' }
add_relationship <- function(
  entityset,
  parent_set,
  child_set,
  parent_idx,
  child_idx
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

  entity_parent_set_pos <- es_names$entity_idx[es_names$entity_name == parent_set][[1]]
  entity_child_set_pos <- es_names$entity_idx[es_names$entity_name == child_set][[1]]
  index_parent_set_pos <- es_names$variable_idx[es_names$variable_name == parent_idx & es_names$entity_name == parent_set]
  index_child_set_pos <- es_names$variable_idx[es_names$variable_name == child_idx & es_names$entity_name == child_set]

  if (length(index_parent_set_pos) == 0) {
    stop("Couldn't find index column `", parent_idx, "` in `", parent_set, "`")
  }

  if (length(index_child_set_pos) == 0) {
    stop("Couldn't find index column `", child_idx, "` in `", child_set, "`")
  }

  # Construct new relationship
  rel <- .ft$Relationship(
    entityset$entities[[entity_parent_set_pos]]$variables[[index_parent_set_pos]],
    entityset$entities[[entity_child_set_pos]]$variables[[index_child_set_pos]]
  )

  # Add relationship to entityset
  entityset <- entityset$add_relationship(rel)

  return(entityset)
}
