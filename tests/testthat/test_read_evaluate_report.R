context("Read evaluate report")

testthat::test_that("read_evaluate_report() works", {
  transaction <- "evaluate_163966785813042760"
  # Read XML
  vcr::use_cassette("read_evaluate_report", {
    qualityReport <- read_evaluate_report(transaction, env = "staging")
  })
  expect_true("xml_document" %in% class(qualityReport))
  # Read HTML
  vcr::use_cassette("read_evaluate_report_html", {
    qualityReport <- read_evaluate_report(
      transaction, 
      as = "html", 
      env = "staging"
    )
  })
  expect_true("xml_document" %in% class(qualityReport))
  # Read char
  vcr::use_cassette("read_evaluate_report_char", {
    qualityReport <- read_evaluate_report(
      transaction, 
      as = "char", 
      env = "staging"
    )
  })
  expect_type(qualityReport, "character")
})
