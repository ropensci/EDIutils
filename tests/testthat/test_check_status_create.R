context("Check status create")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  transaction <- "create_163966765080210573__edi.595.1"
  expect_true(check_status_create(transaction, env = "staging"))
  expect_true(check_status_create(transaction, wait = FALSE, env = "staging"))
})
