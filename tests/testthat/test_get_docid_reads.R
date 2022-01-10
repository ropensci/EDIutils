context("Get doc ID reads")

testthat::test_that("Test attributes of returned object", {
  res <- get_docid_reads("knb-lter-sgs", "817")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("resource" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("resourceId", "resourceType", "scope", "identifier", 
                         "revision", "totalReads", "nonRobotReads")
  expect_true(all(children_found %in% children_expected))
})
 