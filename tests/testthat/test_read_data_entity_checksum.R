context("Read data entity checksum")

testthat::test_that("Test attributes of returned object", {
  pkg <- list(scope = "edi", id = "193", rev = "5")
  entityId <- list_data_entities(pkg$scope, pkg$id, pkg$rev)
  package.id <- paste(pkg, collapse = ".")
  res <- read_data_entity_checksum(package.id, entityId[1])
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})