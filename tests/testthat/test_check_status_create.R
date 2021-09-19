context("Check status evaluation")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.468.2.xml"
  packageId <- "edi.468.1"
  transaction <- create_data_package(path, tier = "staging")
  res <- check_status_create(transaction, packageId, tier = "staging")
  expect_true(is.logical(res))
})