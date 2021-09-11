context("List reservation identifiers")

testthat::test_that("Test attributes of returned object", {
  res <- list_reservation_identifiers("edi")
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
})
