context("Create reservation")

testthat::test_that("create_reservation() works", {
  vcr::use_cassette("create_reservation", {
    identifier <- create_reservation("edi", "staging")
  })
  expect_type(identifier, "double")
  vcr::use_cassette("create_reservation_delete_reservation", {
    res <- delete_reservation("edi", identifier, env = "staging")
  })
  expect_type(res, "double")
})
