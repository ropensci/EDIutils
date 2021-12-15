context("Delete event subscription")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  packageId <- get_test_package()
  url <- "https://some.server.org"
  subscriptionId <- create_event_subscription(packageId, url, env = "staging")
  res <- delete_event_subscription(subscriptionId, env = "staging")
  expect_true(class(res) %in% "logical")
})
