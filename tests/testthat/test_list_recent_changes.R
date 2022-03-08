context("List recent changes")

testthat::test_that("list_recent_changes() works", {
  skip_if_logged_out()
  res <- res <- list_recent_changes(
    fromDate = "2021-01-01T00:00:00",
    toDate = "2021-02-01T00:00:00",
    scope = "knb-lter-hbr",
    as = "xml")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataPackage" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("packageId", "scope", "identifier", "revision",
                         "principal", "doi", "serviceMethod", "date")
  expect_true(all(children_found %in% children_expected))
})
