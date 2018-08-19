#' Create entityset and entity from data frame.
#' @description Create an entityset with a selected `data.frame` as an entity.
#' @export
#'
#' @param .data The `data.frame` to be added as an entity to entityset.
#' @param id The id of this entityset.
#' @param index Name of id column in the dataframe.
#' @param time_index Name of the time column in the dataframe.
#' @param ... Additional variables passed to `add_entity`.
#' @return A modified entityset.
#'
#' @examples
#' as_entityset(cars, index = "row_number")
as_entityset <- function(.data,
                         id = "entityset",
                         index = NA,
                         time_index = NULL,
                         entity_id = "df1",
                         ...) {

  # Sanitize input.
  if(class(.data) != "data.frame") stop("`.data` is not of type `data.frame`")
  if(is.na(id)) stop("`id` cannot be `NA`. Leave empty for default name.")
  if(nrow(.data) == 0) warning("`.data` contains zero rows.`")

  # Create entityset.
  ft <- reticulate::import("featuretools")
  es <- ft$EntitySet(id = id)

  # If index is unset, warn user and create a new index variable.
  if(is.na(index)) {
    warning("`index` is `NA`. Using new variable `row_number` as index.")
    .data <- dplyr::ungroup(.data)
    .data$rownumber = 1:nrow(.data)
  }

  # Add first entity to entityset.
  es <- add_entity(
    entityset = es,
    entity_id = entity_id,
    df = .data,
    index = index,
    time_index = time_index,
    ...
  )

  return(es)
}
