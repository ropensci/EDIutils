context("Summarize evaluate report")

testthat::test_that("Test attributes of returned object", {
  expect_message(
    read_data_package_report_summary(
      packageId = "knb-lter-knz.260.4", 
      with_exceptions = FALSE))
  expect_warning(
    read_data_package_report_summary(
      packageId = "knb-lter-knz.260.4", 
      with_exceptions = TRUE))
})
