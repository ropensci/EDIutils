context("List deleted data packages")

testthat::test_that("Test attributes of returned object", {
  res <- list_deleted_data_packages()
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
