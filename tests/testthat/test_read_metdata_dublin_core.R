context("Read metadata Dublin Core")

testthat::test_that("Test attributes of returned object", {
  res <- read_metadata_dublin_core("knb-lter-nes.10.1")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  children_found <- xml2::xml_name(xml2::xml_children(res))
  children_expected <- c("type", "identifier")
  expect_true(all(children_found %in% children_expected))
})
