context('Read data entity resource metadata')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_read_data_entity_resource_metadata(
        package.id = 'edi.275.4',
        entity.id = '2353ac38985edd6aff140e4c65cb32de',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
