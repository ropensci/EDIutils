context('Test operating system detection')
library(EDIutils)

testthat::test_that('Operating system is accurately detected', {
  
  expect_equal(
    detect_os(),
    detect_os()
  )

})
