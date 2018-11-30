context('Test unit dictionary')
library(EDIutils)

testthat::test_that('Results in NULL output', {
  
  output <- view_unit_dictionary()
  
  expect_equal(
    output,
    NULL
  )

})


