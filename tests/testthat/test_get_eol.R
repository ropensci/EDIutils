context('Test end of line detection')
library(EDIutils)

testthat::test_that('Delimeters are accurately detected', {
  
  path <- system.file('comma_delimited_table.csv', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-26)
  
  # \r\n
  expect_equal(
    get_eol(path = path, file.name = 'eol_rn.txt', 
                     os = 'win'),
    "\\r\\n"
  )
  
  # \n
  expect_equal(
    get_eol(path = path, file.name = 'eol_n.txt', 
            os = 'win'),
    "\\n"
  )
  
  # \r
  expect_equal(
    get_eol(path = path, file.name = 'eol_r.txt', 
            os = 'win'),
    "\\r"
  )
  
})
