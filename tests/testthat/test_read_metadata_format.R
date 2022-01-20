context("Read metadata format")

testthat::test_that("read_metadata_format() works", {
  vcr::use_cassette("read_metadata_format", {
    res <- read_metadata_format("knb-lter-nwt.930.1")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
