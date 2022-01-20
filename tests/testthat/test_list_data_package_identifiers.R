context("List data package identifiers")

testthat::test_that("list_data_package_identifiers() works", {
  vcr::use_cassette("list_data_package_identifiers", {
    res <- list_data_package_identifiers("knb-lter-ble")
  })
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
})
