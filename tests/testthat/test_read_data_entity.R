context("Read data entity")

testthat::test_that("Test attributes of returned object", {
  packageId <- "edi.993.1"
  entityId <- list_data_entities(packageId)
  resp <- read_data_entity(packageId, entityId)
})
