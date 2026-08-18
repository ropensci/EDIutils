context("Read data entity name")

testthat::test_that("read_data_entity_name() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_data_entity_name", {
    entities <- read_data_entity_names(packageId, env = "staging")
    res <- read_data_entity_name(packageId, entities$entityId[1], env = "staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})

