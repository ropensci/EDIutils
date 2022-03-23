context("Get doc ID reads")

testthat::test_that("get_docid_reads() works", {
  vcr::use_cassette("get_docid_reads", {
    res <- get_docid_reads("knb-lter-sgs", "817", as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("resource" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("resourceId", "resourceType", "scope", "identifier", 
                         "revision", "totalReads", "nonRobotReads")
  expect_true(all(children_found %in% children_expected))
})
