context("Evaluate data package")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  # login() # Manually login
  # test_path <- readClipboard() # Create global variable to dir containing test package
  path <- test_path
  # Create data package for evaluation
  identifier <- create_reservation(scope = "edi", env = "staging")
  packageId <- paste0("edi.", identifier, ".1")
  source(system.file("/inst/extdata/test_pkg/test_pkg.R", package = "EDIutils"))
  create_test_eml(test_path, packageId)
  # Evaluate
  eml <- paste0(test_path, "/", packageId, ".xml")
  transaction <- evaluate_data_package(eml, env = "staging")
  res <- check_status_evaluate(transaction, env = "staging")
  expect_true(res)
  # Read evaluation report
  report <- read_evaluate_report(transaction, env = "staging")
  report
  # Summarize evaluation report
  read_evaluate_report_summary(transaction, env = "staging")
  deleted <- delete_reservation("edi", identifier, env = "staging")
})
