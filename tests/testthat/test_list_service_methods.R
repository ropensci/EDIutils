context("List service methods")

testthat::test_that("Test attributes of returned object", {
  res <- list_service_methods()
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
