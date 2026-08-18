context("Read data entity")

testthat::test_that("read_data_entity() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_data_entity", {
    entities <- read_data_entity_names(packageId, env = "staging")
    resp <- read_data_entity(packageId, entities$entityId[1], env = "staging")
  })
  expect_type(resp, "raw")
})

