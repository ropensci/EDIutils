context("Get journal citation")

testthat::test_that("Test attributes of returned object", {
  journalCitations <- list_data_package_citations(packageId = "edi.845.1")
  journalCitationId <- xml2::xml_text(
    xml2::xml_find_first(journalCitations, ".//journalCitationId"))
  res <- get_journal_citation(journalCitationId)
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  children_found <- xml2::xml_name(xml2::xml_children(res))
  children_expected <- c("journalCitationId", "packageId", "principalOwner", 
                         "dateCreated", "articleDoi", "articleTitle", 
                         "articleUrl", "journalTitle", "relationType")
  expect_true(all(children_found %in% children_expected))
})
