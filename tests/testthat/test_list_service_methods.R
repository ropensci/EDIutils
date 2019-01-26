context('List service methods')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      list_service_methods(
        environment = 'production'
      )
    ),
    'character'
  )
  
})
