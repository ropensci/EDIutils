context("Is authorized")

testthat::test_that("is_authorized() works", {
  url <- "https://pasta.lternet.edu/package/report/eml/knb-lter-sbc/6006/3"
  vcr::use_cassette("is_authorized", {
    res <- is_authorized(url)
  })
  expect_true(class(res) %in% "logical")
})
