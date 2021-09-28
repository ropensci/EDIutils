context("Get audit count")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  query <- "category=error&limit=5"
  res <- get_audit_count(query, "staging")
  expect_true(class(res) %in% "numeric")
})
