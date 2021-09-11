context("Is authorized")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  res <- is_authorized("https://pasta.lternet.edu/package/report/eml/knb-lter-sbc/6006/3")
  expect_true(class(res) %in% "numeric")
})