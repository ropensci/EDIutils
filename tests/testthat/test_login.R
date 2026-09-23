context("Login")

testthat::test_that("login() works", {
  vcr::use_cassette("login", {
    expect_error(login("test", "test", env = "staging"))
  })
})

testthat::test_that("login() has default env = 'production'", {
  expect_equal(formals(login)$env, "production")
})

testthat::test_that("login() parses env from config file", {
  config_file <- tempfile()
  on.exit(unlink(config_file))
  writeLines(c("userId = testuser", "userPass = testpass", "env = staging"), config_file)
  
  vcr::use_cassette("login", {
    expect_error(login(config = config_file))
  })
})
