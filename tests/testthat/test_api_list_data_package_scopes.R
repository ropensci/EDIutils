context('List data package scopes')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_data_package_scope(
        environment = 'production'
      )
    ),
    'character'
  )
  
})
