context("Read data entity names")

testthat::test_that("read_data_entity_names() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_data_entity_names", {
    res <- read_data_entity_names(packageId, env = "staging")
  })
  expect_equal(class(res), "data.frame")
  expect_true(all(names(res) %in% c("entityId", "entityName")))
  expect_true(nrow(res) > 0)
})
