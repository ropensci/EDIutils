context('List recent uploads')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_recent_uploads(
        type = 'update',
        limit = 5,
        environment = 'production'
      )
    ),
    c('XMLInternalDocument', 'XMLAbstractDocument')
  )
  
})
