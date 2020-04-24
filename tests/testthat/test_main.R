# This these tests ensures that the most used functions of this package works. Other
# utility functions are tested separately.

# Common functions for all tests.
source("utils.R")

# Create mock data for tests
library(magrittr)
set_size <- 2
value_variables <- 2
set_1 <- generate_mock_data(set_size, value_variables)
set_2 <- generate_mock_data(set_size, value_variables)

# Basic entity creation
test_that("can create entity through as_entityset", {
  skip_if_no_featuretools()

  es <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo")
  expect_true(any(class(es) == "featuretools.entityset.entityset.EntitySet"))
})

# Add multiple entities to set
test_that("can add entity to entityset with add_entity", {
  skip_if_no_featuretools()

  es <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
    add_entity(entity_id = "set_2", df = set_2, index = "key")
  expect_true(length(es$entities) == 2)
  expect_true(all(names(es$entity_dict) == c("set_1", "set_2")))
})

# Add relationship between entities
test_that("can add relationship between two entities", {
  skip_if_no_featuretools()

  es <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
    add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
    add_relationship(
      parent_set = "set_1",
      child_set = "set_2",
      parent_idx = "key",
      child_idx = "key"
    )

  expect_true(is.list(es$relationships) && length(es$relationships) > 0)
})

test_that("relationship can be inherited from parent_idx", {
  skip_if_no_featuretools()

  es <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
    add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
    add_relationship(
      parent_set = "set_1",
      child_set = "set_2",
      parent_idx = "key"
    )

  expect_true(is.list(es$relationships) && length(es$relationships) > 0)
})


# Deep feture synthesis
test_that("can perform dfs", {
  skip_if_no_featuretools()

  es <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
    add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
    add_relationship(
      parent_set = "set_1",
      child_set = "set_2",
      parent_idx = "key",
      child_idx = "key"
    ) %>%
    dfs(target_entity = "set_1", trans_primitives = c("and"))

  expect_true(length(es[[2]]) == 2)
})

# Feature extraction
test_that("can extract features from dfs", {
  skip_if_no_featuretools()

  features <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
    add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
    add_relationship(
      parent_set = "set_1",
      child_set = "set_2",
      parent_idx = "key",
      child_idx = "key"
    ) %>%
    dfs(target_entity = "set_1", trans_primitives = c("and")) %>%
    extract_features()

  expect_true(all(names(features) == c("name", "feature")))
  expect_true(nrow(features) == value_variables)
  expect_true(length(features$feature) == value_variables)
  expect_true(class(features$feature) == "list")
})

# Storing features locally
test_that("can save features", {
  skip_if_no_featuretools()

  as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
    add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
    add_relationship(
      parent_set = "set_1",
      child_set = "set_2",
      parent_idx = "key",
      child_idx = "key"
    ) %>%
    dfs(target_entity = "set_1", trans_primitives = c("and")) %>%
    extract_features() %>%
    save_features(filename = "some.features", path = ".")

  expect_true(file.exists("some.features"))
})

# Loading stored features
test_that("can load features", {
  skip_if_no_featuretools()

  features <- load_features("some.features")
  expect_true(!is.null(features))

  # Cleanup
  if(file.exists("some.features")) file.remove("some.features")
})

# Tidying a feature matrix
test_that("can tidy feature matrix after dfs", {
  skip_if_no_featuretools()

  tidy <- as_entityset(set_1, index = "key", entity_id = "set_1", id = "demo") %>%
    add_entity(entity_id = "set_2", df = set_2, index = "key") %>%
    add_relationship(
      parent_set = "set_1",
      child_set = "set_2",
      parent_idx = "key",
      child_idx = "key"
    ) %>%
    dfs(target_entity = "set_1", trans_primitives = c("and")) %>%
    tidy_feature_matrix(
      remove_nzv = TRUE,
      nan_is_na = TRUE,
      clean_names = TRUE
    )

  expect_true(nrow(tidy) == set_size)
  expect_true(!any(is.nan(tidy$value)))
  expect_true(length(grep("[^A-z0-9_]", names(tidy))) == 0)
})
