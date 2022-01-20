context("Read data package error")

testthat::test_that("read_data_package_error() works", {
  transaction <- "archive_knb-lter-sev.31999.1_16396683904724129"
  vcr::use_cassette("read_data_package_error", {
    res <- read_data_package_error(transaction)
  })
  expect_null(res)
})
