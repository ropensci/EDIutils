context("List data packages PASTA+ is working on")

testthat::test_that("Test attributes of returned object", {
  res <- list_working_on("staging")
  children <- xml2::xml_name(xml2::xml_children(res))
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  if (length(children) != 0) {
    expect_true("dataPackage" %in% children)
  }
})