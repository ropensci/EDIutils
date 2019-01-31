context('List data package identifiers')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_data_package_identifiers(
        scope = 'edi',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
