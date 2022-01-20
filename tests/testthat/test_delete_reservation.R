context("Delete reservation")

testthat::test_that("Test attributes of returned object", {
  # Also tested in test_create_reservation.R
  vcr::skip_if_vcr_off()
  identifier <- 721
  vcr::use_cassette("delete_reservation", {
    res <- delete_reservation("edi", identifier, env = "staging")
  })
  expect_type(res, "double")
})

