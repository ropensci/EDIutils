context('List deleted data packages')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_deleted_data_packages(
        environment = 'production'
      )
    ),
    'character'
  )
  
})
