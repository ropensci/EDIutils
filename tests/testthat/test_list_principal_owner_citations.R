context("List principal owner citations")

testthat::test_that("list_principal_owner_citations() works", {
  vcr::use_cassette("list_principal_owner_citations", {
    principalOwner <- create_dn("csmith")
    res <- list_principal_owner_citations(principalOwner, as = "xml")
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
