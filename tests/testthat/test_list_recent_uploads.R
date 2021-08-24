context("List recent uploads")

testthat::test_that("Test attributes of returned object", {
  res <- list_recent_uploads(type = "update", 5)
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataPackage" %in% xml2::xml_name(xml2::xml_children(res)))
  dd_children <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  expect_true(all(c("packageId", "title", "url") %in% dd_children))
})
