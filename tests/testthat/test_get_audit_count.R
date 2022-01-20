context("Get audit count")

testthat::test_that("get_audit_count() works", {
  vcr::use_cassette("get_audit_count", {
    res <- get_audit_count(
      query = "category=warn&fromTime=2021-12-01&toTime=2021-12-05")
  })
  expect_type(res, "double")
})
