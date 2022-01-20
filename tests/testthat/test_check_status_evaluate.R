context("Check status evaluate")

testthat::test_that("check_status_evaluate() works", {
  transaction <- "evaluate_163966785813042760"
  vcr::use_cassette("check_status_evaluate", {
    res <- check_status_evaluate(transaction, wait = FALSE, env = "staging")
  })
  expect_true(res)
})
