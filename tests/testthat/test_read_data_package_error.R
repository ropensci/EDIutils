context("Read data package error")

testthat::test_that('Test attributes of returned object', {
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.test.xml"
  transaction <- evaluate_data_package(path, tier = "staging")
  Sys.sleep(10)
  expect_error(read_data_package_error(transaction, "staging"))
})