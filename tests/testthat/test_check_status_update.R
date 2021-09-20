context("Check status update")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.468.6.xml"
  transaction <- update_data_package(path, tier = "staging")
  packageId <- "edi.468.6"
  res <- check_status_update(transaction, packageId, tier = "staging")
  expect_true(is.logical(res))
})