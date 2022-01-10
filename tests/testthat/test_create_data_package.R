context("Create data package")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  skip_if_missing_eml_config()
  # Create data package
  identifier <- create_reservation(scope = "edi", env = "staging")
  packageId <- paste0("edi.", identifier, ".1")
  eml <- create_test_eml(path = tempdir(), packageId = packageId)
  on.exit(file.remove(eml), add = TRUE, after = FALSE)
  transaction <- create_data_package(eml, env = "staging")
  # Check creation status
  res <- check_status_create(transaction, env = "staging")
  expect_true(res)
  # Check for EML
  res <- read_metadata(packageId, env = "staging")
  expect_true("xml_document" %in% class(res))
})
