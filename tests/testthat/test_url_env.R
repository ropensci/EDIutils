context('Create PASTA+ environment URL prefix')
library(EDIutils)

testthat::test_that('Output URLs are valid', {
  
  # development
  expect_equal(
    url_env(
      'development'
    ),
    'https://pasta-d'
  )
  
  # staging
  expect_equal(
    url_env(
      'staging'
    ),
    'https://pasta-s'
  )
  
  # production
  expect_equal(
    url_env(
      'production'
    ),
    'https://pasta'
  )
  
})
