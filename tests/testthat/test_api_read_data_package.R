context('Read data package')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_read_data_package(
        package.id = 'edi.275.1',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
