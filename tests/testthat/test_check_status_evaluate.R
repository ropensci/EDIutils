context("Check status evaluate")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  # Create test package
  path <- test_path
  identifier <- create_reservation(scope = "edi", env = "staging")
  packageId <- paste0("edi.", identifier, ".1")
  source(system.file("/inst/extdata/test_pkg/test_pkg.R", package = "EDIutils"))
  create_test_eml(test_path, packageId)
  eml <- paste0(test_path, "/", packageId, ".xml")
  # Evaluate
  transaction <- evaluate_data_package(eml, env = "staging")
  res <- check_status_evaluate(transaction, env = "staging")
  expect_true(res)
  # Summarize report
  expect_message(summarize_evaluate_report(transaction, env = "staging"))
  deleted <- delete_reservation("edi", identifier, env = "staging")
})
