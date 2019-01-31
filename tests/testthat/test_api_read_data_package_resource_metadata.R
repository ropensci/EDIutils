context('Read data package resource metadata')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_read_data_package_resource_metadata(
        package.id = 'edi.100.1',
        environment = 'production'
      )
    ),
    c('XMLInternalDocument', 'XMLAbstractDocument')
  )
  
})
