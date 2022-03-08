context("Read data package resource metadata")

testthat::test_that("read_data_package_resource_metadata() works", {
  packageId <- "edi.613.1"
  vcr::use_cassette("read_data_package_resource_metadata", {
    res <- read_data_package_resource_metadata(packageId, as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  children_found <- xml2::xml_name(xml2::xml_children(res))
  children_expected <- c("dateCreated", "doi", "entityId", "entityName", 
                         "fileName", "identifier", "packageId", 
                         "principalOwner", "resourceId", "resourceType", 
                         "revision", "scope")
  expect_true(all(children_found %in% children_expected))
})
