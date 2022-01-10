context("Read metadata format")

testthat::test_that('Test attributes of returned object', {
  res <- read_metadata_format("knb-lter-nwt.930.1")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
