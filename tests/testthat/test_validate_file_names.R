context('Validate file names')
library(EDIutils)

testthat::test_that('Invalid file names issue an error', {
  
  path <- system.file('comma_delimited_table.csv', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-26)
  
  expect_error(
    validate_file_names(path, c('comma_delimited_table.csv', 'test.txt'))
  )
  
})
