context('Update keywords.txt with controlled vocabularies')
library(EDIutils)

# Parameterize

path <- system.file('keywords.txt', package = 'EDIutils')
path <- substr(path, 1, nchar(path)-13)

# Expect errors

testthat::test_that('Expect errors', {
  expect_error(validate_keywords('test', cv = 'retl'))
})

# Resolve keywords

testthat::test_that('Resolve keywords', {
  expect_equal(
    class(validate_keywords(path, 'lter')), 
    'data.frame')
})

