context("Create event subscription")

testthat::test_that("Test attributes of returned object", {
  res <- create_event_subscription("staging")
  expect_true(class(res) %in% "numeric")
})