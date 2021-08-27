context("Read data entity sizes")

testthat::test_that("Test attributes of returned object", {
  packageId <- "knb-lter-cdr.711.1"
  res <- read_data_entity_sizes(packageId)
  expect_equal(class(res), "data.frame")
  expect_true(all(names(res) %in% c("entityId", "size")))
  expect_true(nrow(res) > 0)
})