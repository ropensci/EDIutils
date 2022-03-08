context("List data package citations")

testthat::test_that("list_data_package_citations() works", {
  vcr::use_cassette("list_data_package_citations", {
    res <- list_data_package_citations("edi.845.1", as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("journalCitation" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("journalCitationId", "packageId", "principalOwner", 
                         "dateCreated", "articleDoi", "articleTitle", 
                         "articleUrl", "journalTitle", "relationType")
  expect_true(all(children_found %in% children_expected))
})
