context('List data sources')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      list_data_sources(
        package.id = 'edi.275.4',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
