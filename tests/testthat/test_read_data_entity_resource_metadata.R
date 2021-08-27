context("Read data entity resource metadata")

testthat::test_that("Test attributes of returned object", {
  packageId <- "knb-lter-cce.310.1"
  entityIds <- list_data_entities(packageId)
  res <- read_data_entity_resource_metadata(packageId, entityIds[1])
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  elements <- c("dataFormat", "dateCreated", "entityId", "entityName", 
                "fileName", "identifier", "md5Checksum", "packageId", 
                "principalOwner", "resourceId", "resourceLocation",
                "resourceSize", "resourceType", "revision", "scope", 
                "sha1Checksum")
  expect_true(all(elements %in% xml2::xml_name(xml2::xml_children(res))))
})
