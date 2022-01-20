context("Check status create")

testthat::test_that("check_status_create() works", {
  transaction <- "create_163966765080210573__edi.595.1"
  # Wait
  vcr::use_cassette("check_status_create_wait", {
    res <- check_status_create(transaction, wait = TRUE, env = "staging")
  })
  expect_true(res)
  # Don't wait
  vcr::use_cassette("check_status_create", {
    res <- check_status_create(transaction, wait = FALSE, env = "staging")
  })
  expect_true(res)
})
