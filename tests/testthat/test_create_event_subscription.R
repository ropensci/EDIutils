context("Create event subscription")

testthat::test_that("Test attributes of returned object", {
  packageId <- get_test_package()
  url <- "https://some.server.org"
  res <- create_event_subscription(packageId, url, tier = "staging")
  on.exit(delete_event_subscription(res, tier = "staging"))
  expect_true(class(res) %in% "numeric")
})