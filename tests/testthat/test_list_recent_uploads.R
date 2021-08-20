context('List recent uploads')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      list_recent_uploads(
        type = 'update',
        limit = 5,
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
