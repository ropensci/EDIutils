context("Create data package archive")

testthat::test_that("Test attributes of returned object", {
  res <- create_data_package_archive("knb-lter-sev.31999.1")
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
})