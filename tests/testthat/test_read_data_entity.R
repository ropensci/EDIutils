context("Read data entity")

testthat::test_that("read_data_entity() works", {
  packageId <- get_test_package()
  entityId <- "58b9000439a5671ea7fe13212e889ba5"
  vcr::use_cassette("read_data_entity", {
    resp <- read_data_entity(packageId, entityId, env = "staging")
  })
  expect_type(resp, "raw")
})
