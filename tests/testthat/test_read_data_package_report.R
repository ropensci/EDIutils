context("Read data package report")

testthat::test_that("Test attributes of returned object", {
  # As xml
  res <- read_data_package_report("knb-lter-knz.260.4")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  found_children <- unique(xml2::xml_name(xml2::xml_children(res)))
  expected_children <- c("creationDate", "packageId", "includeSystem", 
                         "datasetReport", "entityReport")
  expect_true(all(found_children %in% expected_children))
  # As html
  res <- read_data_package_report("knb-lter-knz.260.4", html = TRUE)
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("body" %in% xml2::xml_name(xml2::xml_children(res)))
})
