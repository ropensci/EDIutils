context('Create authentication key for PASTA+')
library(EDIutils)

testthat::test_that('Keys are valid', {
  
  # LTER
  expect_equal(
    auth_key(user.id = 'exampleID', affiliation = 'LTER'),
    'uid=exampleID,o=LTER,dc=edirepository,dc=org'
  )
  
  # EDI
  expect_equal(
    auth_key(user.id = 'exampleID', affiliation = 'EDI'),
    'uid=exampleID,o=EDI,dc=edirepository,dc=org'
  )

})
