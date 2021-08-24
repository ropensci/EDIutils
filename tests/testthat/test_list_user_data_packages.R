context("List user data packages")

testthat::test_that("Test attributes of returned object", {
  res <- list_user_data_packages(get_distinguished_name("dbjourneynorth", "EDI"))
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "packageId")
  expect_true(nrow(res) > 0)
})