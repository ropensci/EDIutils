context("Get recent uploads")

testthat::test_that("get_recent_uploads() works", {
  skip_if_logged_out()
  query <- "serviceMethod=createDataPackage&limit=2"
  res <- get_recent_uploads(query, env = "staging", as = "xml")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("auditRecord" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("oid", "entryTime", "category", "service",
                         "serviceMethod", "responseStatus", "resourceId",
                         "user", "userAgent", "groups", "authSystem",
                         "entryText")
  expect_true(all(children_found %in% children_expected))
})
