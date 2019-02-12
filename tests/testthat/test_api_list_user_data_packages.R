context('List user data packages')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      api_list_user_data_packages(
        dn = 'uid=csmith,o=LTER,dc=ecoinformatics,dc=org',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
