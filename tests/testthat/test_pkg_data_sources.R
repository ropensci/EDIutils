context('Get sources of a data package')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      pkg_data_sources(
        package.id = 'edi.275.4',
        environment = 'production'
      )
    ),
    c('XMLInternalDocument', 'XMLAbstractDocument')
  )
  
})
