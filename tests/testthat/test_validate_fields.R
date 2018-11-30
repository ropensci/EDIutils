context('Test field detection')
library(EDIutils)

testthat::test_that('Number of fields are consistent among rows', {
  
  path <- system.file('comma_delimited_table.csv', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-26)
  
  expect_equal(
    validate_fields(path, 'comma_delimited_table.csv'),
    NULL
  )
  
})


testthat::test_that('Inconsistent number of fields among rows issues an error', {
  
  path <- system.file('comma_delimited_table.csv', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-26)
  
  expect_error(
    validate_fields(path, 'inconsistent_number_of_fields.csv')
  )
  
})

