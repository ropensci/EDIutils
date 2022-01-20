context("Get audit report")

testthat::test_that("get_audit_report() works", {
  query <- paste0("serviceMethod=readDataEntity&fromTime=2021-12-01&toTime=",
                  "2021-12-02&limit=2")
  vcr::use_cassette("get_audit_report", {
    auditReport <- get_audit_report(query)
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
