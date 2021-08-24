context("List deleted data packages")

testthat::test_that("Test attributes of returned object", {
  res <- list_deleted_data_packages()
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "packageId")
  expect_true(nrow(res) > 0)
})