context("Check status evaluation")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  # login()
  path <- test_path
  identifier <- create_reservation(scope = "edi", env = "staging")
  
  packageId <- "edi.468.1"
  transaction <- create_data_package(path, env = "staging")
  res <- check_status_create(transaction, packageId, env = "staging")
  expect_true(is.logical(res))
})


#' path <- "/Users/me/Documents/edi.468.1.xml"
#' transaction <- create_data_package(path)
#' packageId <- "edi.468.1"
#' check_status_create(transaction, packageId)