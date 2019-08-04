# Test utility functions used for the package.

# Common functions for all tests.
source("utils.R")

# Create mock data for tests
library(magrittr)
set_size <- 2
value_variables <- 2
set_1 <- generate_mock_data(set_size)
set_2 <- generate_mock_data(set_size)

# Make sure we can list primitives
test_that("can list primitives", {
  skip_if_no_featuretools()

  primitives <- list_primitives()
  expect_true(nrow(primitives) > 0)
  expect_true(all(names(primitives) == c("name", "type", "description")))
})

# Can create empty entityset
test_that("can create empty entityset", {
  skip_if_no_featuretools()

  es <- create_entityset(id = "my_entityset")

  expect_true(is.list(es$entities))
  expect_true(length(es$entities) == 0)
})
