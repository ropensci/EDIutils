context("Create data package")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.474.1.xml"
  res <- create_data_package(path, env = "staging")
  expect_true(class(res) %in% "character")
})
