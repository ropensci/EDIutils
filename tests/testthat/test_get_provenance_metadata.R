context("Get provenance metadata")

testthat::test_that("get_provenance_metadata() works (mocked test)", {
  vcr::use_cassette("get_provenance_metadata", {
    res <- get_provenance_metadata("knb-lter-pal.309.1")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  children_found <- xml2::xml_name(xml2::xml_children(res))
  children_expected <- c("description", "dataSource")
  expect_true(all(children_found %in% children_expected))
})
