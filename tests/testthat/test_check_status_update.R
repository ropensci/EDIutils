context("Check status update")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  skip_if_missing_eml_config()
  # Create new data packaging
  identifier <- create_reservation(scope = "edi", env = "staging")
  on.exit(delete_reservation("edi", identifier, env = "staging"), add = TRUE, after = FALSE)
  packageId <- paste0("edi.", identifier, ".1")
  eml <- create_test_eml(path = tempdir(), packageId = packageId)
  on.exit(file.remove(eml), add = TRUE, after = FALSE)
  transaction <- create_data_package(eml, env = "staging")
  res <- check_status_create(transaction, packageId, env = "staging")
  # Update data package
  packageId <- paste0("edi.", identifier, ".2")
  eml <- create_test_eml(path = tempdir(), packageId = packageId)
  on.exit(file.remove(eml), add = TRUE, after = FALSE)
  transaction <- update_data_package(eml, env = "staging")
  res <- check_status_update(transaction, packageId, env = "staging")
  expect_true(res)
})
