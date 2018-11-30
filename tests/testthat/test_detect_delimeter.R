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

testthat::test_that('Ambiguity in delimiter guess issues a warning', {
  
  # .txt file with ',' delimiter detected
  expect_message(
    detect_delimeter_2('mock_file_name.txt', ',')
  )
  
})
