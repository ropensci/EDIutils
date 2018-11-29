context('Test delimeter detection')
library(EDIutils)
library(stringr)
library(reader)

testthat::test_that('Delimeters are accurately detected', {
  
  path <- system.file('comma_delimited_table.csv', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-26)
  
  # Comma
  expect_equal(
    detect_delimeter(path = path, data.files = 'comma_delimited_table.csv', 
                     os = 'win'),
    ","
  )
  
  # Tab
  expect_equal(
    detect_delimeter(path = path, data.files = 'tab_delimited_table.txt',
                     os = 'win'),
    "\t"
  )
  
})
