context('Get data package IDs of a scope')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      pkg_ids(
        scope = 'edi',
        environment = 'production'
      )
    ),
    'data.frame'
  )
  
})
