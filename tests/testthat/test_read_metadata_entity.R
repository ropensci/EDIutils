context("Read metadata entity")

testthat::test_that("read_metadata_entity() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_metadata_entity", {
    entities <- read_data_entity_names(packageId, env = "staging")
    res <- read_metadata_entity(packageId, entities$entityId[1], env = "staging")
  })
  expect_true("xml_nodeset" %in% class(res))
  expect_true(any(c("dataTable", "otherEntity", "spatialRaster", "spatialVector", "storedProcedure") %in% xml2::xml_name(res)))
})

