.onAttach <- function(...) {
  message("Attaching featuretoolsR with default options")
}

.onLoad <- function(...){
  options(
    featuretoolsR.force_posixct = TRUE,
    featuretoolsR.posixct_tz = "UTC"
  )
}
