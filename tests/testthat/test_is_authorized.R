context("Is authorized")

testthat::test_that("is_authorized() works", {
  parts <- unlist(strsplit(get_test_package(), ".", fixed=TRUE))
  url <- paste0("https://pasta-s.lternet.edu/package/report/eml/", parts[1], "/", 
               parts[2], "/", parts[3])
  vcr::use_cassette("is_authorized", {
    res <- is_authorized(url, env = "staging")
  })
  expect_true(class(res) %in% "logical")
})
