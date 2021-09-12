context("Create audit record")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  res <- create_audit_record()
  expect_true(class(res) %in% "numeric")
})