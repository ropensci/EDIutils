context('List data entities')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      list_data_entities(
        package.id = 'edi.275.1',
        environment = 'production'
      )
    ),
    'data.frame'
  )
  
})
