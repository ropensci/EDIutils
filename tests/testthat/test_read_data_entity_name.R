context("Read data entity name")

testthat::test_that("read_data_entity_name() works", {
  packageId <- "knb-lter-cap.691.2"
  entityId <- "f6e4efd0b04aea3860724824ca05c5dd"
  vcr::use_cassette("read_data_entity_name", {
    res <- read_data_entity_name(packageId, entityId)
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
