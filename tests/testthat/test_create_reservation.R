context("Create reservation")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  identifier <- create_reservation("edi", "staging")
  on.exit(delete_reservation("edi", identifier, env = "staging"))
  expect_type(identifier, "double")
})
