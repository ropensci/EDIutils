context("List data descendants")

testthat::test_that("list_data_descendants() works", {
  vcr::use_cassette("list_data_descendants", {
    res <- list_data_descendants("knb-lter-bnz.501.17", as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataDescendant" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("packageId", "title", "url")
  expect_true(all(children_found %in% children_expected))
})
