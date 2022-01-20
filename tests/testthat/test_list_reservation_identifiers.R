context("List reservation identifiers")

testthat::test_that("list_reservation_identifiers() works", {
  vcr::use_cassette("list_reservation_identifiers", {
    res <- list_reservation_identifiers("edi")
  })
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
})
