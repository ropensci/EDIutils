context("Delete data package")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  # Create data package
  path <- test_path
  identifier <- create_reservation(scope = "edi", env = "staging")
  packageId <- paste0("edi.", identifier, ".1")
  source(system.file("/inst/extdata/test_pkg/test_pkg.R", package = "EDIutils"))
  create_test_eml(test_path, packageId)
  eml <- paste0(test_path, "/", packageId, ".xml")
  transaction <- create_data_package(eml, env = "staging")
  # Check creation status
  status <- check_status_create(transaction, packageId, env = "staging")
  res <- delete_data_package(scope = "edi", identifier = identifier, env = "staging")
  expect_true(res)
})
