context("Create data package")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.468.2.xml"
  res <- create_data_package(path, tier = "staging")
  expect_true(class(res) %in% "character")
})