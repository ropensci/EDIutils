context("Read data package ACL")

testthat::test_that("Test attributes of returned object", {
  res <- read_data_package_acl("knb-lter-gce.762.17")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataDescendant" %in% xml2::xml_name(xml2::xml_children(res)))
  dd_children <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  expect_true(all(c("packageId", "title", "url") %in% dd_children))
})