context('Read data entity sizes')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      read_data_entity_sizes(
        package.id = 'edi.275.1',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
