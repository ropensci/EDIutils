context("List data package scopes")

testthat::test_that("list_data_package_scopes() works", {
  vcr::use_cassette("list_data_package_scopes", {
    res <- list_data_package_scopes("staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
