context("Read data package report resource metadata")

testthat::test_that("read_data_package_report_resource_metadata() works", {
  vcr::use_cassette("read_data_package_report_resource_metadata", {
    res <- read_data_package_report_resource_metadata(
      packageId = "knb-lter-mcm.9129.3", 
      as = "xml"
    )
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  found_children <- xml2::xml_name(xml2::xml_children(res))
  expected_children <- c("dateCreated", "doi", "entityId", "entityName", 
                         "fileName", "identifier", "packageId", 
                         "principalOwner", "resourceId", "resourceType", 
                         "revision", "scope" )
  expect_true(all(found_children %in% expected_children))
})
