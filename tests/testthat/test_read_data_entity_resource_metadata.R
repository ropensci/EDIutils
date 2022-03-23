context("Read data entity resource metadata")

testthat::test_that("read_data_entity_resource_metadata() works", {
  packageId <- "knb-lter-cce.310.1"
  entityId <- "4aaaff61e0d316130be0b445d3013877"
  vcr::use_cassette("read_data_entity_resource_metadata", {
    res <- read_data_entity_resource_metadata(packageId, entityId, as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  children_found <- xml2::xml_name(xml2::xml_children(res))
  children_expected <- c("dataFormat", "dateCreated", "entityId", "entityName", 
                         "fileName", "identifier", "md5Checksum", "packageId", 
                         "principalOwner", "resourceId", "resourceLocation",
                         "resourceSize", "resourceType", "revision", "scope", 
                         "sha1Checksum")
  expect_true(all(children_found %in% children_expected))
})
