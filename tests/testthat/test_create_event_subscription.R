context("Create event subscription")

testthat::test_that("Test attributes of returned object", {
  packageId <- "knb-lter-vcr.340.1"
  url <- "https://some.server.org"
  res <- create_event_subscription(packageId, url)
  on.exit(delete_event_subscription(res))
  expect_true(class(res) %in% "numeric")
})