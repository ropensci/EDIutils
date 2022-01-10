context("Login")

testthat::test_that("Test attributes of returned object", {
  expect_error(login("test", "test"))
})