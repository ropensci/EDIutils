context("List data sources")

testthat::test_that("Test attributes of returned object", {
  res <- list_data_sources("edi.275.4")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataSource" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("packageId", "title", "url")
  expect_true(all(children_found %in% children_expected))
})