context("Delete reservation")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  res <- create_reservation("edi", "staging")
  res <- delete_reservation("edi", res, "staging")
  expect_true(class(res) %in% "numeric")
})

