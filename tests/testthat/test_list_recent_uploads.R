context("List recent uploads")

testthat::test_that("list_recent_uploads() works", {
  vcr::use_cassette("list_recent_uploads", {
    res <- list_recent_uploads(type = "update", limit = 5, as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataPackage" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("packageId", "scope", "identifier", "revision", 
                         "principal", "doi", "serviceMethod", "date")
  expect_true(all(children_found %in% children_expected))
})
