context("Read data package DOI")

testthat::test_that("read_data_package_doi() works", {
  vcr::use_cassette("read_data_package_doi", {
    res <- read_data_package_doi("knb-lter-jrn.210548103.15")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})
