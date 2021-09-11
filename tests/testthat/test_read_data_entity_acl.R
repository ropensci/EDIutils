context("Read data entity access control list")

testthat::test_that("Test attributes of returned object", {
  packageId <- "edi.100.4"
  entityId <- list_data_entities(packageId)
  res <- read_data_entity_acl(packageId, entityId[1])
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataDescendant" %in% xml2::xml_name(xml2::xml_children(res)))
  dd_children <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  expect_true(all(c("packageId", "title", "url") %in% dd_children))
})