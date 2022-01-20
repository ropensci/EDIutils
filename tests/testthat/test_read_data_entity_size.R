context("Read data entity size")

testthat::test_that("read_data_entity_size() works", {
  packageId <- "knb-lter-cdr.711.1"
  entityId <- "c61703839eac9a641ea0c3c69dc3345b"
  vcr::use_cassette("read_data_entity_size", {
    res <- read_data_entity_size(packageId, entityId)
  })
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
})
