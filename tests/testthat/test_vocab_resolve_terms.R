context('Resolve terms to a controlled vocabulary')
library(EDIutils)

# Parameterize

recognized_terms <- c(
  'air temperature',
  'maximum temperature',
  'minimum temperature',
  'soil temperature'
)

unrecognized_terms <- c(
  'nonsense terms',
  'one eyed one horned flying purple people eater',
  '8he89ghgpo'
)

# Expect data frame

# testthat::test_that('Output should be a data frame', {
#   expect_equal(class(vocab_resolve_terms(recognized_terms, 'lter')), 'data.frame')
# })

# Expect no resolution

# testthat::test_that('No resolution expected', {
#   output <- vocab_resolve_terms(unrecognized_terms, 'lter')
#   use_i <- output$controlled_vocabulary == ''
#   expect_equal(sum(use_i),3)
# })

# Expect errors

testthat::test_that('Expect errors', {
  expect_error(vocab_resolve_terms(65))
  expect_error(vocab_resolve_terms('air temperature', cv = 'retl'))
  expect_error(vocab_resolve_terms('air temperature', messages = T, interactive = T))
})

