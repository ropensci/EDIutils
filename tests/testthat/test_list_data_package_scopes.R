context("List data package scopes")

testthat::test_that("Test attributes of returned object", {
  res <- list_data_package_scopes("staging")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
