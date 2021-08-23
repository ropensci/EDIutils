context("List data package identifiers")

testthat::test_that('Test attributes of returned object', {
  res <- list_data_package_identifiers("edi", environment = "staging")
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "identifier")
  expect_true(nrow(res) > 0)
})