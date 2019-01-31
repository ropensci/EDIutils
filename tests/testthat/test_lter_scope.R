context('Search for a LTER CV scope description.')
library(EDIutils)

# Expect character

testthat::test_that('Output should be character.', {
  expect_equal(class(lter_scope(65)), 'character')
})

# Expect errors

testthat::test_that('Expect errors', {
  expect_error(lter_scope('65'))
  expect_error(lter_scope(65, 75))
})

