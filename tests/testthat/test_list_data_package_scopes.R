context('List data package scopes')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      list_data_package_scopes(
        environment = 'production'
      )
    ),
    'character'
  )
  
})
