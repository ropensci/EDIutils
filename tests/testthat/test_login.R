context("Login")

testthat::test_that("login() works", {
  vcr::use_cassette("login", {
    expect_error(login("test", "test"))
  })
})
