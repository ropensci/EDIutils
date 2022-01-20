context("Summarize evaluate report")

testthat::test_that("read_data_package_report_summary() works", {
  vcr::skip_if_vcr_off()
  vcr::use_cassette("read_data_package_report_summary", {
    expect_message(
      read_data_package_report_summary(
        packageId = "knb-lter-knz.260.4",
        with_exceptions = FALSE))
  })
  vcr::use_cassette("read_data_package_report_summary_with_exceptions", {
    expect_warning(
      read_data_package_report_summary(
        packageId = "knb-lter-knz.260.4",
        with_exceptions = TRUE))
  })
})
