context("Get event subscription schema")

testthat::test_that("Test attributes of returned object", {
  res <- get_event_subscription_schema()
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("element" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("complexType")
  expect_true(all(children_found %in% children_expected))
})