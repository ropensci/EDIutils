context("Read data package error")

testthat::test_that('Test attributes of returned object', {
  res <- read_data_package_error()
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})