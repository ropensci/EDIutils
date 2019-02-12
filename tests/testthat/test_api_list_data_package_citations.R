context('Get data package EML')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_data_package_citations(
        package.id = 'edi.100.1',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
