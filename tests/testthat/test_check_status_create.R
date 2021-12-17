context("Check status create")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  skip_if_missing_eml_config()
  # Create test package
  identifier <- create_reservation(scope = "edi", env = "staging")
  on.exit(delete_reservation("edi", identifier, env = "staging"), add = TRUE)
  packageId <- paste0("edi.", identifier, ".1")
  eml <- create_test_eml(path = tempdir(), packageId = packageId)
  on.exit(file.remove(eml), add = TRUE)
  transaction <- create_data_package(eml, env = "staging")
  # Check status
  res <- check_status_create(transaction, packageId, env = "staging")
  expect_true(res)
})
