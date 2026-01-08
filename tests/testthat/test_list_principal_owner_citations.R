context("List principal owner citations")

testthat::test_that("list_principal_owner_citations() works", {
  vcr::use_cassette("list_principal_owner_citations", {
    principalOwner <- "EDI-543afa80c859825d35d37d9111c24a4a65a0db9f"
    res <- list_principal_owner_citations(principalOwner, as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("journalCitation" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("journalCitationId", "packageId", "principalOwner",
                         "dateCreated", "articleDoi", "articleTitle", 
                         "articleUrl", "journalTitle", "relationType", 
                         "pubDate", "journalIssue", "journalVolume", 
                         "articlePages", "articleAuthors")
  expect_true(all(children_found %in% children_expected))
})
