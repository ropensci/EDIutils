context("Get audit record")

testthat::test_that("get_audit_record() works (real call)", {
  skip_if_logged_out()
  uploads <- get_recent_uploads(query = "serviceMethod=createDataPackage&limit=1")
  oid <- uploads$oid
  auditReport <- get_audit_record(oid, as = "xml")
  res <- xml2::xml_find_first(auditReport, ".//auditRecord")
  children_found <- xml2::xml_name(xml2::xml_children(res))
  children_expected <- c("oid", "entryTime", "category", "service",
                         "serviceMethod", "responseStatus", "resourceId",
                         "user", "userAgent", "groups", "authSystem",
                         "entryText")
  expect_true(all(children_found %in% children_expected))
})
