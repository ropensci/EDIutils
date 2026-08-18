context("Summarize evaluate report")

testthat::test_that("read_data_package_report_summary() works", {
  vcr::skip_if_vcr_off()
  pkg <- get_test_package()
  vcr::use_cassette("read_data_package_report_summary", {
    expect_message(
      read_data_package_report_summary(
        packageId = pkg,
        with_exceptions = FALSE,
        env = "staging"))
  })
  vcr::use_cassette("read_data_package_report_summary_with_exceptions", {
    expect_warning(
      read_data_package_report_summary(
        packageId = pkg,
        with_exceptions = TRUE,
        env = "staging"))
  })
})
