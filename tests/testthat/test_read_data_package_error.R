context("Read data package error")

testthat::test_that('Test attributes of returned object', {
  # res <- read_data_package_error("archive_knb-lter-sev.31999.1_163146068346152007")
  # res <- read_data_package_error("knb-lter-sev/31999/1/163146068346152007")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})