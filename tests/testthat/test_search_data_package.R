context('Create reservation')
library(EDIutils)

testthat::test_that('Invalid request results in error', {
  
  path <- system.file('edi.151.4.xml', package = 'EDIutils')
  path <- substr(path, 1, nchar(path)-14)
  
  expect_error(
    create_reservation(scope = 'edi', environment = 'staging', 
                   user.id = 'myuserid', user.pass = 'mypassword', 
                   affiliation = 'LTER'
                   )
  )
  
})


testthat::test_that('Test polling loop', {
  
  expect_error(
    poll_pkg_reserve_id(list(status_code = 401))
  )
  expect_error(
    poll_pkg_reserve_id(list(status_code = 400))
  )
  
})
