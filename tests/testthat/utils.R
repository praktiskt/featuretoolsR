library(testthat)

featuretools_available <- function() {
  return(reticulate::py_module_available("featuretools"))
}

skip_if_no_featuretools <- function() {
  if (!featuretools_available())
    skip("required featuretools module not available for testing")
}

generate_mock_data <- function(size = 2, value_variables = 2) {
  options(stringsAsFactors = TRUE)
  d <- data.frame(key = 1:size)
  for (i in 1:value_variables) {
    colnames <- c(names(d), paste0("value", i))
    d <- cbind(d, data.frame("new" = sample(1:10, size, TRUE)))
    names(d) <- colnames
  }
  return(d)
}
