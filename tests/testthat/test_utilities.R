context('Utility functions')

testthat::test_that('PASTA URLs are valid', {
  # development
  expect_equal(base_url('development'), 'https://pasta-d.lternet.edu')
  # staging
  expect_equal(base_url('staging'), 'https://pasta-s.lternet.edu')
  # production
  expect_equal(base_url('production'), 'https://pasta.lternet.edu')
})




testthat::test_that('Portal URLs are valid', {
  # development
  expect_equal(
    base_url_portal('development'), 'https://portal-d.edirepository.org')
  # staging
  expect_equal(
    base_url_portal('staging'), 'https://portal-s.edirepository.org')
  # production
  expect_equal(
    base_url_portal('production'), 'https://portal.edirepository.org')
})




testthat::test_that('Landing page URLs are constructed', {
  res <- read_data_package_landing_page_url("edi.100.1")
  expect_true(class(res) == "character")
})