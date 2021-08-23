context("List data package revisions")

testthat::test_that("Test attributes of returned object", {
  # All revisions
  res <- list_data_package_revisions("edi", "275")
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "revision")
  expect_true(nrow(res) > 0)
  # Newest revision
  res <- list_data_package_revisions("edi", "275", filter = "newest")
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "revision")
  expect_true(as.numeric(res$revision) > 1)
  # Oldest revision
  res <- list_data_package_revisions("edi", "275", filter = "oldest")
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "revision")
  expect_true(as.numeric(res$revision) == 1)
})