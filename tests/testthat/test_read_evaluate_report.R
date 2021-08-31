context("Read evaluate report")

testthat::test_that("Test attributes of returned object", {
  # As xml
  res <- read_evaluate_report("knb-lter-mcr.7011.0")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  found_children <- xml2::xml_name(xml2::xml_children(res))
  expected_children <- c("creationDate", "packageId", "includeSystem", 
                         "includeSystem", "datasetReport", "entityReport")
  expect_true(all(found_children %in% expected_children))
  expect_true(length(xml2::xml_find_all(res, ".//creationDate")) != 0)
  # As html
  res <- read_evaluate_report("knb-lter-knz.260.4", html = TRUE)
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("body" %in% xml2::xml_name(xml2::xml_children(res)))
})


#' # Result in XML format
#' read_data_package_report("knb-lter-knz.260.4")
#' 
#' # Result in HTML format
#' read_data_package_report("knb-lter-knz.260.4", html = TRUE)