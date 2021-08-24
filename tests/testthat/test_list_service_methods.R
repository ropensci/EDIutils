context("List service methods")

testthat::test_that("Test attributes of returned object", {
  res <- list_service_methods()
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "serviceMethod")
  expect_true(nrow(res) > 0)
})
