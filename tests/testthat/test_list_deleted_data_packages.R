context("List deleted data packages")

testthat::test_that("list_deleted_data_packages() works", {
  vcr::use_cassette("list_deleted_data_packages", {
    res <- list_deleted_data_packages()
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
