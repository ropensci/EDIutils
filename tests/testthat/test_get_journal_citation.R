context("Get journal citation")

testthat::test_that("get_journal_citation() works ", {
  vcr::use_cassette("list_data_package_citations", {
    journalCitations <- list_data_package_citations(
      packageId = "edi.845.1", 
      as = "xml"
    )
  })
  journalCitationId <- xml2::xml_text(
    xml2::xml_find_first(journalCitations, ".//journalCitationId"))
  vcr::use_cassette("get_journal_citation", {
    res <- get_journal_citation(journalCitationId, as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  children_found <- xml2::xml_name(xml2::xml_children(res))
  children_expected <- c("journalCitationId", "packageId", "principalOwner", 
                         "dateCreated", "articleDoi", "articleTitle", 
                         "articleUrl", "journalTitle", "relationType")
  expect_true(all(children_found %in% children_expected))
})
