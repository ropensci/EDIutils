context("Execute event subscription")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  # Create subscription
  packageId <- get_test_package()
  url <- "https://some.server.org"
  subscriptionId <- create_event_subscription(packageId, url, env = "staging")
  expect_type(subscriptionId, "double")
  # Execute subscription
  res <- execute_event_subscription(subscriptionId, env = "staging")
  expect_true(res)
  # Delete subscription
  res <- delete_event_subscription(subscriptionId, env = "staging")
  expect_true(res)
})
