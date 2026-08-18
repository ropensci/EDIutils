context("Read data package archive")

testthat::test_that("read_data_package_archive() issues deprecation warning", {
  # Test that the read_data_package_archive() function issues a deprecation 
  # warning when the transaction parameter is used.
  testthat::skip_on_cran()
  pkg <- get_test_package()
  vcr::use_cassette("read_data_package_archive_warn", {
    testthat::expect_warning(
      object = {
        res <- read_data_package_archive(
          packageId = pkg, 
          transaction = "archive_edi.1923.1_16396683904724129", 
          path = tempdir(),
          env = "staging"
        )
      },
      regexp = "The 'transaction' parameter is deprecated"
    )
  })
  archive <- paste0(pkg, ".zip")
  if (file.exists(paste0(tempdir(), "/", archive))) {
    file.remove(paste0(tempdir(), "/", archive))
  }
})


testthat::test_that("read_data_package_archive() works with transaction", {
  # Test that the read_data_package_archive() function works when the 
  # transaction argument is used.
  testthat::skip_on_cran()
  pkg <- get_test_package()
  vcr::use_cassette("read_data_package_archive_with_tx", {
    res <- suppressWarnings(
      read_data_package_archive(
        packageId = pkg, 
        transaction = "archive_edi.1923.1_16396683904724129", 
        path = tempdir(),
        env = "staging"
      )
    )
  })
  archive <- paste0(pkg, ".zip")
  if (!file.exists(paste0(tempdir(), "/", archive)) && is.raw(res$content)) {
    writeBin(res$content, paste0(tempdir(), "/", archive))
  }
  expect_true(archive %in% dir(tempdir()))
  if (file.exists(paste0(tempdir(), "/", archive))) {
    file.remove(paste0(tempdir(), "/", archive))
  }
})


testthat::test_that("read_data_package_archive() works without transaction", {
  # Test that the read_data_package_archive() function works when the 
  # transaction argument is not used.
  testthat::skip_on_cran()
  pkg <- get_test_package()
  vcr::use_cassette("read_data_package_archive", {
    res <- suppressWarnings(
      read_data_package_archive(
        packageId = pkg, 
        path = tempdir(),
        env = "staging"
      )
    )
  })
  archive <- paste0(pkg, ".zip")
  if (!file.exists(paste0(tempdir(), "/", archive)) && is.raw(res$content)) {
    writeBin(res$content, paste0(tempdir(), "/", archive))
  }
  expect_true(archive %in% dir(tempdir()))
  if (file.exists(paste0(tempdir(), "/", archive))) {
    file.remove(paste0(tempdir(), "/", archive))
  }
})

