context('Get EML attributes')
library(EDIutils)

testthat::test_that('Valid attributes return a list of content', {
  
  expect_equal(
    get_eml_attribute(attr.name = 'wind_speed', package.id = 'knb-lter-cap.46.15'),
    list(name = 'wind_speed', definition = 'wind speed', unit = 'kilometersPerHour')
  )
  
})