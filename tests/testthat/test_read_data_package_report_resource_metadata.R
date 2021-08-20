context('Read data package report resource metadata')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      read_data_package_report_resource_metadata(
        package.id = 'edi.100.1',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
