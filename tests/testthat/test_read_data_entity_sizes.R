context("Read data entity sizes")

testthat::test_that("read_data_entity_sizes() works", {
  packageId <- get_test_package()
  vcr::use_cassette("read_data_entity_sizes", {
    res <- read_data_entity_sizes(packageId, env = "staging")
  })
  expect_equal(class(res), "data.frame")
  expect_true(all(names(res) %in% c("entityId", "size")))
  expect_true(nrow(res) > 0)
})
