context("Evaluate data package")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  skip_if_missing_eml_config()
  # Create data package for evaluation
  identifier <- create_reservation(scope = "edi", env = "staging")
  packageId <- paste0("edi.", identifier, ".1")
  eml <- create_test_eml(path = tempdir(), packageId = packageId)
  on.exit(file.remove(eml), add = TRUE, after = FALSE)
  # Evaluate
  transaction <- evaluate_data_package(eml, env = "staging")
  res <- check_status_evaluate(transaction, env = "staging")
  expect_true(res)
  # Read evaluation report
  report <- read_evaluate_report(transaction, env = "staging")
  expect_true("xml_document" %in% class(report))
  deleted <- delete_reservation("edi", identifier, env = "staging")
})
