context("List data entities")

testthat::test_that("list_data_entities() works", {
  pkg <- get_test_package()
  vcr::use_cassette("list_data_entities", {
    res <- list_data_entities(pkg, env = "staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
