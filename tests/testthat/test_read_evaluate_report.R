context("Read evaluate report")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  # Evaluate data package
  path <- test_path
  identifier <- create_reservation(scope = "edi", env = "staging")
  on.exit(delete_reservation("edi", identifier, env = "staging"))
  packageId <- paste0("edi.", identifier, ".1")
  source(system.file("/inst/extdata/test_pkg/test_pkg.R", package = "EDIutils"))
  create_test_eml(test_path, packageId)
  eml <- paste0(test_path, "/", packageId, ".xml")
  transaction <- evaluate_data_package(eml, env = "staging")
  res <- check_status_evaluate(transaction, env = "staging")
  expect_true(res)
  # Read XML
  qualityReport <- read_evaluate_report(transaction, env = "staging")
  expect_true("xml_document" %in% class(qualityReport))
  # Read HTML
  qualityReport <- read_evaluate_report(transaction, format = "html", env = "staging")
  expect_true("xml_document" %in% class(qualityReport))
  # Read char
  qualityReport <- read_evaluate_report(transaction, format = "char", env = "staging")
  expect_type(qualityReport, "character")
})
