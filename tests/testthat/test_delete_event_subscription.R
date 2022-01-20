context("Delete event subscription")

testthat::test_that("delete_event_subscription() works", {
  # The real test is in test_execute_event_subscription.R
  vcr::skip_if_vcr_off()
  subscriptionId <- 270
  vcr::use_cassette("delete_event_subscription", {
    res <- delete_event_subscription(subscriptionId, env = "staging")
  })
  expect_true(res)
})
