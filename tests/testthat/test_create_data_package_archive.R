context("Create data package archive")

testthat::test_that("create_data_package_archive() works (mock test)", {
  vcr::skip_if_vcr_off()
  vcr::use_cassette("create_data_package_archive", {
    packageId <- "knb-lter-sev.31999.1"
    transaction <- suppressWarnings(
      create_data_package_archive(packageId)
    )
  })
  expect_true(class(transaction) == "character")
})

testthat::test_that("create_data_package_archive() issues warning", {
  # Test that the create_data_package_archive() function issues a deprecation 
  # warning when called.
  skip_if_logged_out()
  testthat::expect_warning(
    object = create_data_package_archive("knb-lter-sev.31999.1"),
    regexp = "The 'create_data_package_archive' function is deprecated."
  )
})
