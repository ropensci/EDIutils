context('Get provenance metadata')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      get_provenance_metadata(
        package.id = 'edi.100.1',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
