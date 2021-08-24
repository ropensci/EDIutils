context('Read data entity name')

testthat::test_that('Test attributes of returned object', {
  res <- list_data_package_identifiers("edi", environment = "staging")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      read_data_entity_name(
        package.id = 'edi.275.1',
        identifier = '5c224a0e74547b14006272064dc869b1',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
