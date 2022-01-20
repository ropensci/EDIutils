context("List service methods")

testthat::test_that("list_service_methods() works", {
  vcr::use_cassette("list_service_methods", {
    res <- list_service_methods()
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
