context("Get audit count")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  res <- get_audit_count(
    query = "category=warn&fromTime=2021-12-01&toTime=2021-12-05")
  expect_type(res, "double")
})
