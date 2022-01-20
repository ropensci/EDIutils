context("Create data package archive")

testthat::test_that("create_data_package_archive() works (mock test)", {
  vcr::skip_if_vcr_off()
  vcr::use_cassette("create_data_package_archive", {
    packageId <- "knb-lter-sev.31999.1"
    transaction <- create_data_package_archive(packageId)
  })
  expect_true(class(transaction) == "character")
})

testthat::test_that("create_data_package_archive() works", {
  skip_if_logged_out()
  # Create zip archive
  packageId <- "knb-lter-sev.31999.1"
  transaction <- create_data_package_archive(packageId)
  # Download zip archive
  read_data_package_archive(packageId, transaction, path = tempdir())
  archive <- paste0(packageId, ".zip")
  expect_true(archive %in% dir(tempdir()))
})
