context('Validate function arguments')
library(EDIutils)

testthat::test_that('Valid arguments do not result in error', {

  # affiliation
  expect_equal(
    validate_arguments(
      list(affiliation = 'LTER')
    ),
    NULL
  )
  expect_equal(
    validate_arguments(
      list(affiliation = 'EDI')
    ),
    NULL
  )

  # environment
  expect_equal(
    validate_arguments(
      list(environment = 'development')
    ),
    NULL
  )
  expect_equal(
    validate_arguments(
      list(environment = 'staging')
    ),
    NULL
  )
  expect_equal(
    validate_arguments(
      list(environment = 'production')
    ),
    NULL
  )

  # os
  expect_equal(
    validate_arguments(
      list(os = 'mac')
    ),
    NULL
  )
  expect_equal(
    validate_arguments(
      list(os = 'win')
    ),
    NULL
  )
  expect_equal(
    validate_arguments(
      list(os = 'lin')
    ),
    NULL
  )
  
  # package.id
  expect_equal(
    validate_arguments(
      list(package.id = 'edi.141.5')
    ),
    NULL
  )
  expect_equal(
    validate_arguments(
      list(package.id = 'knb-lter-cap.298.45')
    ),
    NULL
  )

})


testthat::test_that('Malformed arguments result in errors', {

  # affiliation
  expect_error(
    validate_arguments(
      list(affiliation = 'LTERrrr')
    )
  )

  # environment
  expect_error(
    validate_arguments(
      list(environment = 'developmenting')
    )
  )

  # os
  expect_error(
    validate_arguments(
      list(os = 'macwin')
    )
  )
  
  # package.id
  expect_error(
    validate_arguments(
      list(package.id = 'edi.141')
    )
  )
  expect_error(
    validate_arguments(
      list(package.id = 'edi.141.3.4')
    )
  )

})




testthat::test_that('Test validate_path.R', {
  
  expect_error(
    validate_path('somepath')
  )
  
})