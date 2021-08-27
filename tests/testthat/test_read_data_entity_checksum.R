context("Read data entity checksum")

testthat::test_that("Test attributes of returned object", {
  packageId <- "knb-lter-ble.1.7"
  entityId <- list_data_entities(packageId)
  res <- read_data_entity_checksum(packageId, entityId[1])
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})