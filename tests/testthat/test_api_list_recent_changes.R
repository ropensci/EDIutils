context('List recent changes')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_recent_changes(
        from.date = '2019-01-20T12:00:00',
        to.date = '2019-01-25T12:00:00',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
  expect_equal(
    class(
      api_list_recent_changes(
        from.date = '2019-01-20T12:00:00',
        to.date = '2019-01-25T12:00:00',
        scope = 'edi',
        environment = 'production'
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
