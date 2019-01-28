context('List data package revisions')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_data_package_revisions(
        scope = 'edi',
        identifier = '275',
        environment = 'production'
      )
    ),
    'character'
  )
  
  expect_equal(
    class(
      api_list_data_package_revisions(
        scope = 'edi',
        identifier = '275',
        filter = 'newest',
        environment = 'production'
      )
    ),
    'character'
  )
  
  expect_equal(
    class(
      api_list_data_package_revisions(
        scope = 'edi',
        identifier = '275',
        filter = 'oldest',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
