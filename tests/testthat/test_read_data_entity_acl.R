context("Read data entity access control list")

testthat::test_that("Test attributes of returned object", {
  pkg <- get_test_package()
  entityId <- list_data_entities(pkg$scope, pkg$id, pkg$rev, environment = "staging")
  entityId <- entityId$entityId[1]
  res <- read_data_entity_acl(paste(pkg, collapse = "."), entityId, environment = "staging")
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "entityId")
  expect_true(nrow(res) > 0)
})

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      read_data_entity_checksum(
        package.id = 'edi.275.1',
        identifier = '5c224a0e74547b14006272064dc869b1',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
