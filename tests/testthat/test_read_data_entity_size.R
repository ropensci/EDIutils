context("Read data entity size")

testthat::test_that("read_data_entity_size() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_data_entity_size", {
    entities <- read_data_entity_names(packageId, env = "staging")
    res <- read_data_entity_size(packageId, entities$entityId[1], env = "staging")
  })
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
})

