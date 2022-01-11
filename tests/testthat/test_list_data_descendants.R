context("List data descendants")

testthat::test_that("Test attributes of returned object", {
  res <- list_data_descendants("knb-lter-bnz.501.17")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataDescendant" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("packageId", "title", "url")
  expect_true(all(children_found %in% children_expected))
})