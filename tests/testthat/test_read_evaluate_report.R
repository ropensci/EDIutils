context("Read evaluate report")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  path <- "/Users/csmith/Documents/EDI/datasets/pkg_ediutils_test/edi.468.1.xml"
  transaction <- evaluate_data_package(path, tier = "staging")
  # As xml
  res <- read_evaluate_report(transaction, tier = "staging")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  found_children <- xml2::xml_name(xml2::xml_children(res))
  expected_children <- c("creationDate", "packageId", "includeSystem", 
                         "datasetReport", "entityReport")
  expect_true(all(found_children %in% expected_children))
  # As html
  res <- read_evaluate_report(transaction, html = TRUE, tier = "staging")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("body" %in% xml2::xml_name(xml2::xml_children(res)))
})