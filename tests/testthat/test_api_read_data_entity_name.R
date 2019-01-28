context('Read data entity name')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_read_data_entity_checksum(
        package.id = 'edi.275.1',
        identifier = '5c224a0e74547b14006272064dc869b1',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
