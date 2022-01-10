context("List data entities")

testthat::test_that("Test attributes of returned object", {
  pkg <- get_test_package()
  res <- list_data_entities(pkg, "staging")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
