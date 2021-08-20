context('Get EML attributes')
library(EDIutils)

testthat::test_that('Valid attributes return a list of content', {
  
  output <- get_eml_attribute(attr.name = 'wind_speed', package.id = 'knb-lter-cap.46.15')
  expected <- list(definition = 'wind speed', unit = 'kilometersPerHour', name = 'wind_speed')
  
  expect_equal(
    sum(output %in% expected) == 3,
    TRUE
  )
  
  output <- get_eml_attribute(attr.name = 'biomass', package.id = 'knb-lter-bnz.501.17')
  expected <- list(name = 'biomass', definition = 'aboveground biomass', unit = 'gbiomassm-2')
  
  expect_equal(
    sum(output %in% expected) == 3,
    TRUE
  )
  
})