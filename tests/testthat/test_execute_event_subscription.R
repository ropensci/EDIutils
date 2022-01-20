context("Execute event subscription")

testthat::test_that("execute_event_subscription() works (mock test)", {
  vcr::skip_if_vcr_off()
  subscriptionId <- 270
  vcr::use_cassette("execute_event_subscription", {
    res <- execute_event_subscription(subscriptionId, env = "staging")
  })
  expect_true(res)
})

testthat::test_that("execute_event_subscription() works", {
  skip_if_logged_out()
  # Create subscription
  packageId <- get_test_package()
  url <- paste0("https://some.server.", sample(1:100, 1), ".org")
  subscriptionId <- create_event_subscription(packageId, url, env = "staging")
  expect_type(subscriptionId, "double")
  # Execute subscription
  res <- execute_event_subscription(subscriptionId, env = "staging")
  expect_true(res)
  # Delete subscription
  res <- delete_event_subscription(subscriptionId, env = "staging")
  expect_true(res)
})
