context('List data packages PASTA+ is working on')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_working_on(
        environment = 'production'
      )
    ),
    c('XMLInternalDocument', 'XMLAbstractDocument')
  )
  
})
