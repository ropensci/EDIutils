context("Read data package archive")

testthat::test_that("Test attributes of returned object", {
  packageId <- "knb-lter-vcr.340.1"
  transaction <- create_data_package_archive(packageId)
  res <- read_data_package_archive(packageId, transaction)
})