context("List user data packages")

testthat::test_that("list_user_data_packages() works", {
  vcr::use_cassette("list_user_data_packages", {
    res <- list_user_data_packages(edi_id = "EDI-543afa80c859825d35d37d9111c24a4a65a0db9f")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
