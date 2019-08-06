#' add_entity
#' @description Add an entity to an entityset.
#' @export
#'
#' @param entityset The entity set to modify.
#' @param entity_id The name of the entity to add.
#' @param df The data frame to add as an entity.
#' @param index The index parameter specifies the column that uniquely identifies rows in the dataframe
#' @param time_index Name of the time column in the dataframe.
#' @param ... Additional parameters passed to `featuretools.entity_from_dataframe`.
#' @return A modified entityset.
#'
#' @examples
#' \donttest{
#' library(magrittr)
#' create_entityset("set") %>%
#'   add_entity(df = cars,
#'              entity_id = "cars",
#'              index = "row_number")
#' }
add_entity <- function(
  entityset,
  entity_id,
  df,
  index = NULL,
  time_index = NULL,
  ...
) {
  # Construct variable_types to handle factors as categorical variables.
  classes <- purrr::map_dfr(sapply(df, FUN = function(col) {
    c <- class(col)
    # prettify difficult data types
    if(length(c > 1))
      c <- paste0(c, collapse = ", ")
    return(c)
  }), c)

  variable_types = list() #initialize
  if (any(classes == "factor")) {
    for (i in 1:length(classes)) {
      suppressWarnings({
        if (class(df[, i]) == "factor") {
          variable_types[[names(df)[i]]] <- .ft$variable_types$Categorical
        }
      })
    }
  }

  variable_types <- reticulate::r_to_py(variable_types)

  # Add df as entity to entityset.
  es <- entityset$entity_from_dataframe(
    entity_id = entity_id,
    dataframe = reticulate::r_to_py(x = df),
    index = index,
    time_index = time_index,
    variable_types = variable_types,
    ...
  )

  return(es)

}
