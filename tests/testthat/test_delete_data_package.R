context("Delete data package")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.474.1.xml"
  res <- create_data_package(path, env = "staging")
  check_status_create(res, "edi.474.1", env = "staging")
  res <- delete_data_package("edi", "474", "staging")
  expect_true(class(res) %in% "logical")
})
