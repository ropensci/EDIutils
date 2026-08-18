context("List data package revisions")

testthat::test_that("list_data_package_revisions() works", {
  # All revisions
  vcr::use_cassette("list_data_package_revisions", {
    res <- list_data_package_revisions("edi", "1923", env = "staging")
  })
  expect_equal(class(res), "numeric")
  expect_true(length(res) > 0)
  # Newest revision
  vcr::use_cassette("list_data_package_revisions_newest", {
    res <- list_data_package_revisions("edi", "1923", filter = "newest", env = "staging")
  })
  expect_equal(class(res), "numeric")
  expect_true(as.numeric(res) >= 1)
  # Oldest revision
  vcr::use_cassette("list_data_package_revisions_oldest", {
    res <- list_data_package_revisions("edi", "1923", filter = "oldest", env = "staging")
  })
  expect_equal(class(res), "numeric")
  expect_true(as.numeric(res) == 1)
})
