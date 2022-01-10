context("Read data package error")

testthat::test_that("Test attributes of returned object", {
  # Also tested in read_data_package_archive.R
  transaction <- "archive_knb-lter-sev.31999.1_16396683904724129"
  expect_null(read_data_package_error(transaction))
})
