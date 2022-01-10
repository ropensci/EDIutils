context("Read data entity size")

testthat::test_that('Test attributes of returned object', {
  packageId <- "knb-lter-cdr.711.1"
  entityIds <- list_data_entities(packageId)
  res <- read_data_entity_size(packageId, entityIds[1])
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
})
