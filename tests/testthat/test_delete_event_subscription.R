context("Delete event subscription")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  packageId <- "knb-lter-vcr.340.1"
  url <- "https://some.server.org"
  subscriptionId <- create_event_subscription(packageId, url)
  res <- delete_event_subscription(subscriptionId)
  expect_true(class(res) %in% "logical")
})



