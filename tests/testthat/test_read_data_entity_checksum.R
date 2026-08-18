context("Read data entity checksum")

testthat::test_that("read_data_entity_checksum() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_data_entity_checksum", {
    entities <- read_data_entity_names(packageId, env = "staging")
    res <- read_data_entity_checksum(packageId, entities$entityId[1], env = "staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})

