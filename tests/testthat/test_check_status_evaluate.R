context("Check status evaluation")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.468.4.xml"
  transaction <- evaluate_data_package(path, env = "staging")
  res <- check_status_evaluate(transaction, env = "staging")
  expect_true(is.logical(res))
})
