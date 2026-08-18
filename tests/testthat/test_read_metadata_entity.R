context("Read metadata entity")

testthat::test_that("read_metadata_entity() works", {
  packageId <- get_test_package()
  entityId <- "f6e4efd0b04aea3860724824ca05c5dd"
  vcr::use_cassette("read_metadata_entity", {
    res <- read_metadata_entity(packageId, entityId, env = "staging")
  })
  expect_true("xml_nodeset" %in% class(res))
  expect_true(all("dataTable" %in% xml2::xml_name(res)))
})
