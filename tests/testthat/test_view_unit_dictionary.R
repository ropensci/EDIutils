context('View unit dictionary')
library(EDIutils)

# Expect output

testthat::test_that('Expect list', {
  expect_equal(
    class(view_unit_dictionary()),
    'list'
  )
})