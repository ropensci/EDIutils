context("Get audit report")

testthat::test_that("Test attributes of returned object", {
  query <- "category=error&limit=5"
  res <- get_audit_report(query, "staging")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("auditRecord" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("oid", "entryTime", "category", "service", 
                         "serviceMethod", "responseStatus", "resourceId", 
                         "user", "userAgent", "groups", "authSystem", 
                         "entryText")
  expect_true(all(children_found %in% children_expected))
})
