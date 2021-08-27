context("Read data entity names")

testthat::test_that('Test attributes of returned object', {
  packageId <- "knb-lter-cap.691.2"
  res <- read_data_entity_names(packageId)
  expect_equal(class(res), "data.frame")
  expect_true(all(names(res) %in% c("entityId", "entityName")))
  expect_true(nrow(res) > 1)
})



read_data_entity_names("knb-lter-cap.691.2")