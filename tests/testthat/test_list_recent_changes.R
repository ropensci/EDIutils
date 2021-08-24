context("List recent changes")

testthat::test_that("Test attributes of returned object", {
  res <- res <- list_recent_changes(
    fromDate = "2021-01-01T00:00:00", 
    toDate = "2021-02-01T00:00:00", 
    scope = "knb-lter-hbr")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataPackage" %in% xml2::xml_name(xml2::xml_children(res)))
  dp_children <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  expect_true(
    all(c("packageId", "scope", "identifier", "revision", "principal", "doi", 
          "serviceMethod", "date") %in% dp_children))
})
