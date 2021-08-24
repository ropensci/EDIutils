context("List user data packages")

testthat::test_that("Test attributes of returned object", {
  res <- list_user_data_packages(get_distinguished_name("dbjourneynorth", "EDI"))
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})