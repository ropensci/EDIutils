context("Summarize evaluate report")

testthat::test_that("evaluate_report_summary() works", {
  transaction <- "evaluate_163966785813042760"
  vcr::use_cassette("read_evaluate_report_summary", {
    expect_message(
      read_evaluate_report_summary(transaction, env = "staging"))
  })
})
