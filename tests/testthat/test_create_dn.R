context("Create distinguished name")

testthat::test_that("Test attributes of returned object", {
  # Create distinguished name within EDI organizational unit
  userId <- "my_userid"
  ou <- "EDI"
  dn <- create_dn(userId, ou)
  expect_true(grepl("edirepository", dn))
  # Create distinguished name within LTER organizational unit
  userId <- "my_userid"
  ou <- "LTER"
  dn <- create_dn(userId, ou)
  expect_true(grepl("ecoinformatics", dn))
})
