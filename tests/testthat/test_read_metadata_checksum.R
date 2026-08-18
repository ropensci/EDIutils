context("Read metadata checksum")

testthat::test_that("read_metadata_checksum() works", {
  vcr::use_cassette("read_metadata_checksum", {
    res <- read_metadata_checksum(get_test_package(), env = "staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
