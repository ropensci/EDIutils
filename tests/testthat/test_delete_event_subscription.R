context("Delete event subscription")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  packageId <- get_test_package()
  url <- "https://some.server.org"
  subscriptionId <- create_event_subscription(packageId, url, tier = "staging")
  res <- delete_event_subscription(subscriptionId, tier = "staging")
  expect_true(class(res) %in% "logical")
})