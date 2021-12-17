context("Create data package archive")

testthat::test_that("Test attributes of returned object", {
  # Create zip archive
  packageId <- "knb-lter-sev.31999.1"
  transaction <- create_data_package_archive(packageId)
  # Download zip archive
  read_data_package_archive(packageId, transaction, path = tempdir())
  archive <- paste0(packageId, ".zip")
  expect_true(archive %in% dir(tempdir()))
})
