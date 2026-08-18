context("Read data entity resource metadata")

testthat::test_that("read_data_entity_resource_metadata() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_data_entity_resource_metadata", {
    entities <- read_data_entity_names(packageId, env = "staging")
    res <- read_data_entity_resource_metadata(packageId, entities$entityId[1], as = "xml", env = "staging")
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

