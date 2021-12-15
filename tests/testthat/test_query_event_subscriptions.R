context("Query event subscriptions")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  res <- query_event_subscriptions(env = "staging")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("subscription" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("id", "creator", "packageId", "url")
  expect_true(all(children_found %in% children_expected))
})
