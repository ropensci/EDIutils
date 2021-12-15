context('Create EDI repository environment URL prefix')
library(EDIutils)

testthat::test_that('Output URLs are valid', {
  
  # development
  expect_equal(
    base_url('development'), 'https://pasta-d.lternet.edu'
  )
  
  # staging
  expect_equal(
    base_url('staging'), 'https://pasta-s.lternet.edu')
  
  # production
  expect_equal(
    base_url('production'), 'https://pasta.lternet.edu')
  
})
