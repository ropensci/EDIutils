context('Test end of line detection')
library(EDIutils)

testthat::test_that('End of line characters are accurately detected', {
  
  path <- system.file('comma_delimited_table.csv', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-26)
  os <- detect_os()
  
  expect_equal(
    get_eol(path, 'eol_rn.txt', os),
    '\\n'
  )
  expect_equal(
    get_eol(path, 'eol_n.txt', os),
    '\\n'
  )
  expect_equal(
    get_eol(path, 'eol_r.txt', os),
    '\\r'
  )
  
})
  
  
testthat::test_that('Test parse_delim.R', {
  
  expect_equal(
    parse_delim('test\r\ntest'),
    '\\r\\n'
  )
  expect_equal(
    parse_delim('test\ntest'),
    '\\n'
  )
  expect_equal(
    parse_delim('test\rtest'),
    '\\r'
  )
  
})
