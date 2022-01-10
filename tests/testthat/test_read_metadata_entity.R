context("Read metadata entity")

testthat::test_that("Test attributes of returned object", {
  packageId <- "knb-lter-cap.691.2"
  entities <- read_data_entity_names(packageId)
  res <- read_metadata_entity(packageId, entityId = entities$entityId[1])
  expect_true("xml_nodeset" %in% class(res))
  expect_true(all("dataTable" %in% xml2::xml_name(res)))
})
