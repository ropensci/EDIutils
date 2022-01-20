context("Check status update")

testthat::test_that("check_status_update() works", {
  vcr::skip_if_vcr_off()
  transaction <- "create_163966765080210573__edi.595.1"
  vcr::use_cassette("check_status_update", {
    res <- check_status_update(transaction, wait = FALSE, env = "staging")
  })
  expect_true(res)
  vcr::use_cassette("check_status_update_wait", {
    res <- check_status_update(transaction, wait = TRUE, env = "staging")
  })
  expect_true(res)
})
