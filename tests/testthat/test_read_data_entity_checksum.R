context("Read data entity checksum")

testthat::test_that("read_data_entity_checksum() works", {
  packageId <- get_test_package()
  entityId <- "a1723e0e5f3c4881f1a7ede1b036aba6"
  vcr::use_cassette("read_data_entity_checksum", {
    res <- read_data_entity_checksum(packageId, entityId, env = "staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
