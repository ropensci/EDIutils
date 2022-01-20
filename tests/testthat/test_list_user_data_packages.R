context("List user data packages")

testthat::test_that("list_user_data_packages() works", {
  vcr::use_cassette("list_user_data_packages", {
    res <- list_user_data_packages(create_dn("dbjourneynorth", "EDI"))
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
