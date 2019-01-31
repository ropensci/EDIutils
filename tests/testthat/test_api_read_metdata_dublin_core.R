context('Read metadata Dublin Core')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_read_metadata_dublin_core(
        package.id = 'edi.100.1',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
