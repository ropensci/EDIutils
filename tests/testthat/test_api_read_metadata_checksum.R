context('Read metadata checksum')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_read_metadata_checksum(
        package.id = 'edi.275.1',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
