# featuretoolsR
An R interface to the Python module Featuretools.

# General
`featuretoolsR` provides functionality from the Python module `featuretools`, which aims to automate feature engineering. This package is very much a work in progress as Featuretools offers a lot of functionality. Any PRs are much appreciated.

# Installing

## Package
### CRAN
The latest stable release is found on [CRAN](https://cran.r-project.org/package=featuretoolsR).

### Github
You can get the latest version of `featuretoolsR` by installing it straight from Github:  `devtools::install_github("magnusfurugard/featuretoolsR")`.

## Featuretools
You'll need to have a working Python environment as well as `featuretools` installed. The recommended way is to use the built-in function `install_featuretools()` which automatically sets up a virtual environment for the package and installs `featuretools`.

# Usage
All functions in `featuretoolsR` comes with documentation, but it's advised to briefly browse through the [Featuretools Python documentation](https://docs.featuretools.com/). It'll cover things like `entities`, `relationships` and `dfs`. 

## Creating an entityset
An entityset is the set which contain all your entities. To create a set and add an entity straight away, you can use `as_entityset`. 
```
# Libs
library(featuretoolsR)
library(magrittr)

# Create some mock data
set_1 <- data.frame(key = 1:100, value = sample(letters, 100, T), a = rep(Sys.Date(), 100))
set_2 <- data.frame(key = 1:100, value = sample(LETTERS, 100, T), b = rep(Sys.time(), 100))

# Create entityset
es <- as_entityset(
  set_1, 
  index = "key", 
  entity_id = "set_1", 
  id = "demo", 
  time_index = "a"
)
```

## Adding entities
To add entities (i.e if you have relational data across multiple `data.frames`), this can be achieved with `add_entity`. This function is pipe friendly. For this demo-case, we'll use `set_2`.
```
es <- es %>%
  add_entity(
    df = set_2, 
    entity_id = "set_2", 
    index = "key", 
    time_index = "b"
  )
```

## Defining relationships
With relational data, it's useful to define a relationship between two or more entities. This can be done with `add_relationship`.
```
es <- es %>%
  add_relationship(
    parent_set = "set_1", 
    child_set = "set_2", 
    parent_idx = "key", 
    child_idx = "key"
  )
```

## Deep feature synthesis
The bread and butter of Featuretools is the `dfs`-function (official docs [here](https://docs.featuretools.com/en/stable/automated_feature_engineering/afe.html)). It will attempt to create features based on `*_primitives` you provide (more on primitives below).
```
ft_matrix <- es %>%
  dfs(
    target_entity = "set_1", 
    trans_primitives = c("and", "cum_sum")
  )
```

## Tidying up
To use the new data.frame/features created by `dfs`, a function unique for `featuretoolsR`, `tidy_feature_matrix` can be used. A few "nice-to-have" arguments can be passed to clean the new data, like removing near zero variance variables, as well as replacing `NaN` with `NA`.
```
tidy <- tidy_feature_matrix(ft_matrix, remove_nzv = T, nan_is_na = T, clean_names = T)
```

# Primitives
Featuretools supports a lot of primitives. These are accessible with the function `list_primitives()` which returns a data.frame containing type (aggregation (`agg_primitives`) or transform (`trans_primitives`)), name (in the example above, "and" and "divide") as well as a brief description of the primitive itself.

# Credits
[reticulate](https://github.com/rstudio/reticulate) - an R interface to Python.

[Featuretools](https://github.com/Featuretools/featuretools)
