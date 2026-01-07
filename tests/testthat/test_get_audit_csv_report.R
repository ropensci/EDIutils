context("Get audit csv report")

testthat::test_that("get_audit_csv_report() works", {
  query <- "serviceMethod=readDataEntity&limit=1"
  vcr::use_cassette("get_audit_csv_report", {
    auditReport <- get_audit_csv_report(query)
  })
  expect_true("data.frame" %in% class(auditReport))
  expected_columns <- c(
    "Oid", "EntryTime", "Service", "Category", "ServiceMethod", "EntryText",
    "ResourceId", "ResponseStatus", "User", "UserAgent", "Groups", "AuthSystem"
    )
  expect_true(all(expected_columns %in% colnames(auditReport)))
})
