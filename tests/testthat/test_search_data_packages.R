context("Search data packages")

testthat::test_that("Test attributes of returned object", {
  query <- 'q="air+temperature"&fl=*'
  res <- search_data_packages(query)
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("document" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("abstract", "begindate", "doi", "enddate", "funding", 
                         "geographicdescription", "id", "methods", "packageid", 
                         "pubdate", "responsibleParties", "scope", "site", 
                         "taxonomic", "title", "authors", "spatialCoverage", 
                         "sources", "keywords", "organizations", "singledates", 
                         "timescales")
  expect_true(all(children_found %in% children_expected))
})

