context('Validate file names')
library(EDIutils)

testthat::test_that('Non-existant files throw an error', {
  
  path <- system.file('comma_delimited_table.csv', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-26)
  
  expect_error(
    validate_file_names(
      path = path, 
      data.files = c('comma_delimited_table.csv', 'test.txt')
    )
  )
  
})

testthat::test_that('Poorly named files throw a warning', {
  
  f1 <- file.create(paste0(tempdir(), "/file name with spaces.csv"))
  
  expect_warning(
    validate_file_names(
      path = tempdir(), 
      data.files = "file name with spaces.csv"
    )
  )
  
  unlink(
    paste0(tempdir(), "/file name with spaces.csv"),
    recursive = TRUE,
    force = TRUE
  )
  
})