context("Read data entity")

testthat::test_that("read_data_entity() works", {
  packageId <- "edi.1047.1"
  entityId <- "58b9000439a5671ea7fe13212e889ba5"
  vcr::use_cassette("read_data_entity", {
    resp <- read_data_entity(packageId, entityId)
  })
  expect_type(resp, "raw")
})
