context('List data entities')

testthat::test_that('Test attributes of returned object', {
  pkg <- get_test_package()
  res <- list_data_entities(pkg$scope, pkg$id, pkg$rev, environment = "staging")
  expect_equal(class(res), "data.frame")
  expect_true(names(res) == "entityId")
  expect_true(nrow(res) > 0)
})
