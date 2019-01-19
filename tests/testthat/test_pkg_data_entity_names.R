context('Get data entity names and IDs from data package')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      pkg_data_entity_names(
        package.id = 'edi.100.1',
        environment = 'production'
      )
    ),
    'data.frame'
  )
  
})
