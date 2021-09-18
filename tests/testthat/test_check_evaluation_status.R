context("Poll evaluate report")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.468.1.xml"
  transaction <- evaluate_data_package(path, tier = "staging")
  res <- check_evaluation_status(transaction, tier = "staging")
  expect_true(all(names(res) %in% c("evaluated", "resp")))
  expect_equal(class(res$evaluated), "logical")
  expect_equal(class(res$resp), "response")
})