context("List data package scopes")

testthat::test_that("Test attributes of returned object", {
  res <- list_data_package_scopes(environment = "staging")
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "scope")
  expect_true(nrow(res) > 0)
})