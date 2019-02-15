context('Search for a term in the LTER CV')
library(EDIutils)

# Expect class logical

# testthat::test_that('Output should be of logical class', {
#   expect_equal(class(vocab_lter_term('water temperature')), 'logical')
# })

# Expect messages

testthat::test_that('Expect messages when terms are not found', {
  expect_message(vocab_lter_term('ast', messages = T))
})

# Expect errors

testthat::test_that('Expect errors', {
  expect_error(vocab_lter_term(65))
  expect_error(vocab_lter_term(c('ast', 'tsa')))
  expect_error(vocab_lter_term('ast', messages = T, interactive = T))
})
