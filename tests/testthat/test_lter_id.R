context('Search for an LTER CV term ID')

library(EDIutils)

# Parameterize

output <- lter_id('water temperature')

# Expect numeric output

testthat::test_that('Output should be numeric.', {
  expect_equal(class(output), 'numeric')
})

# Expect error

testthat::test_that('Error should result from invalid terms.', {
  expect_error(lter_id('ast'))
  expect_error(lter_id(123))
  expect_error(lter_id(c('temperature', 'water')))
})