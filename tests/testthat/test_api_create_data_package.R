context('Create data package')
library(EDIutils)

testthat::test_that('Invalid request results in error', {
  
  path <- system.file('edi.151.4.xml', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-14)
  
  expect_error(
    api_create_data_package(path = path, package.id = 'edi.151.4', environment = 'staging',
               user.id = 'myuserid', user.pass = 'mypassword', 
               affiliation = 'LTER')
  )
  
})
