context("Read data package report checksum")

testthat::test_that("read_data_package_report_checksum() works", {
  vcr::use_cassette("read_data_package_report_checksum", {
    res <- read_data_package_report_checksum(get_test_package(), env = "staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
