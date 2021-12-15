context("Create event subscription")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  packageId <- get_test_package()
  url <- "https://some.server.org"
  res <- create_event_subscription(packageId, url, env = "staging")
  on.exit(delete_event_subscription(res, env = "staging"))
  expect_true(class(res) %in% "numeric")
})
