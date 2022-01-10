context("Check status evaluate")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  transaction <- "evaluate_163966785813042760"
  expect_false(check_status_evaluate(transaction, wait = FALSE, env = "staging"))
})
