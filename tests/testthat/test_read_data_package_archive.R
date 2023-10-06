context("Read data package archive")

testthat::test_that("read_data_package_archive() issues deprecation warning", {
  # Test that the read_data_package_archive() function issues a deprecation 
  # warning when the transaction parameter is used.
  testthat::skip_on_cran()
  testthat::expect_warning(
    object = read_data_package_archive(
      packageId = "knb-lter-cdr.444.8", 
      transaction = "archive_knb-lter-cdf.444.8_16396683904724129", 
      path = tempdir()),
    regexp = "The 'transaction' parameter is deprecated"
  )
  archive <- "knb-lter-cdr.444.8.zip"
  file.remove(paste0(tempdir(), "/", archive))
})


testthat::test_that("read_data_package_archive() works with transaction", {
  # Test that the read_data_package_archive() function works when the 
  # transaction argument is used.
  testthat::skip_on_cran()
  suppressWarnings(
    read_data_package_archive(
      packageId = "knb-lter-cdr.444.8", 
      transaction = "archive_knb-lter-cdf.444.8_16396683904724129", 
      path = tempdir()
    )
  )
  archive <- "knb-lter-cdr.444.8.zip"
  expect_true(archive %in% dir(tempdir()))
  file.remove(paste0(tempdir(), "/", archive))
})


testthat::test_that("read_data_package_archive() works without transaction", {
  # Test that the read_data_package_archive() function works when the 
  # transaction argument is not used.
  testthat::skip_on_cran()
  suppressWarnings(
    read_data_package_archive(
      packageId = "knb-lter-cdr.444.8", 
      path = tempdir()
    )
  )
  archive <- "knb-lter-cdr.444.8.zip"
  expect_true(archive %in% dir(tempdir()))
  file.remove(paste0(tempdir(), "/", archive))
})
