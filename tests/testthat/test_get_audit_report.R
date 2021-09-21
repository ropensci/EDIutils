context("Get audit report")

testthat::test_that("Test attributes of returned object", {
  query <- "category=error"
  res <- get_audit_report(query, "staging")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("reservation" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("docid", "principal", "dateReserved")
  expect_true(all(children_found %in% children_expected))
})

# namespace strip checker
xml2::xml_find_all(res, ".//articleUrl")
#
