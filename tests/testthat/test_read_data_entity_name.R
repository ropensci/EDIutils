context("Read data entity name")

testthat::test_that('Test attributes of returned object', {
  packageId <- "knb-lter-cap.691.2"
  entityIds <- list_data_entities(packageId)
  res <- read_data_entity_name(packageId, entityIds[1])
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})