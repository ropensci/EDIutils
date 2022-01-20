context("List data package revisions")

testthat::test_that("list_data_package_revisions() works", {
  # All revisions
  vcr::use_cassette("list_data_package_revisions", {
    res <- list_data_package_revisions("edi", "275")
  })
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
  # Newest revision
  vcr::use_cassette("list_data_package_revisions_newest", {
    res <- list_data_package_revisions("edi", "275", filter = "newest")
  })
  expect_equal(class(res), "numeric")
  expect_true(as.numeric(res) > 1)
  # Oldest revision
  vcr::use_cassette("list_data_package_revisions_oldest", {
    res <- list_data_package_revisions("edi", "275", filter = "oldest")
  })
  expect_equal(class(res), "numeric")
  expect_true(as.numeric(res) == 1)
})
