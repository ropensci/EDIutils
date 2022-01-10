context("Read metadata checksum")

testthat::test_that('Test attributes of returned object', {
  res <- read_metadata_checksum("knb-lter-ntl.409.1")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
