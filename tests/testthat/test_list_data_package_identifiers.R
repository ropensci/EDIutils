context("List data package identifiers")

testthat::test_that('Test attributes of returned object', {
  res <- list_data_package_identifiers("edi", environment = "staging")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
