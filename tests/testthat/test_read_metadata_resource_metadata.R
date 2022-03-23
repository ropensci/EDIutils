context("Read metadata resource metadata")

testthat::test_that("read_metadata_resource_metadata() works", {
  vcr::use_cassette("read_metadata_resource_metadata", {
    res <- read_metadata_resource_metadata("knb-lter-pal.309.1", as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  children_expected <- c("dateCreated", "entityId", "entityName", "fileName", 
                         "formatType", "identifier", "md5Checksum", 
                         "packageId", "principalOwner", "resourceId", 
                         "resourceType", "revision", "scope", "sha1Checksum")
  children_found <- xml2::xml_name(xml2::xml_children(res))
  expect_true(all(children_found %in% children_expected))
})
