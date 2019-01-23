context('Get data package revisions')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      pkg_revisions(
        scope = 'edi',
        identifier = '275',
        environment = 'production'
      )
    ),
    'integer'
  )
  
  expect_equal(
    class(
      pkg_revisions(
        scope = 'edi',
        identifier = '275',
        filter = 'newest',
        environment = 'production'
      )
    ),
    'integer'
  )
  
  expect_equal(
    class(
      pkg_revisions(
        scope = 'edi',
        identifier = '275',
        filter = 'oldest',
        environment = 'production'
      )
    ),
    'integer'
  )
  
})
