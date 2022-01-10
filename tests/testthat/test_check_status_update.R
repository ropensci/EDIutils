context("Check status update")

testthat::test_that("Test attributes of returned object", {
  # Also tested in test_update_data_package.R
  skip_if_logged_out()
  transaction <- "create_163966765080210573__edi.595.1"
  expect_true(check_status_update(transaction, env = "staging"))
  expect_true(check_status_update(transaction, wait = FALSE, env = "staging"))
})
