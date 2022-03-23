context("List data packages the EDI repository is working on")

testthat::test_that("list_working_on() works", {
  vcr::use_cassette("list_working_on", {
    res <- list_working_on(as = "xml", "staging")
  })
  children <- xml2::xml_name(xml2::xml_children(res))
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  if (length(children) != 0) {
    expect_true("dataPackage" %in% children)
  }
})
