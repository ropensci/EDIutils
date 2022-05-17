context("Get audit report")

testthat::test_that("get_audit_report() works", {
  query <- "serviceMethod=readDataEntity&limit=1"
  vcr::use_cassette("get_audit_report", {
    auditReport <- get_audit_report(query, as = "xml")
  })
  expect_true("xml_document" %in% class(auditReport))
  expect_true("auditRecord" %in% 
                xml2::xml_name(xml2::xml_children(auditReport)))
  # Get first audit record
  auditRecord <- xml2::xml_find_first(auditReport, ".//auditRecord")
  children_found <- xml2::xml_name(xml2::xml_children(auditRecord))
  children_expected <- c("oid", "entryTime", "category", "service",
                         "serviceMethod", "responseStatus", "resourceId",
                         "user", "userAgent", "groups", "authSystem",
                         "entryText")
  expect_true(all(children_found %in% children_expected))
})
