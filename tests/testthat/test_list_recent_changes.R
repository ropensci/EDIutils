context("List recent changes")

testthat::test_that("list_recent_changes() works", {
  skip_if_logged_out()
  res <- list_recent_changes(
    fromDate = "2021-01-01T00:00:00",
    toDate = "2021-02-01T00:00:00",
    scope = "edi",
    as = "xml",
    env = "staging")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataPackage" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("packageId", "scope", "identifier", "revision",
                         "principal", "doi", "serviceMethod", "date")
  expect_true(all(children_found %in% children_expected))
})

testthat::test_that("list_recent_changes() requires authentication", {
  orig_token <- Sys.getenv("EDI_TOKEN", "")
  orig_key <- Sys.getenv("EDI_API_KEY", "")
  on.exit({
    if (orig_token == "") Sys.unsetenv("EDI_TOKEN") else Sys.setenv(EDI_TOKEN = orig_token)
    if (orig_key == "") Sys.unsetenv("EDI_API_KEY") else Sys.setenv(EDI_API_KEY = orig_key)
  })
  
  Sys.unsetenv("EDI_TOKEN")
  Sys.unsetenv("EDI_API_KEY")
  expect_error(
    list_recent_changes(
      fromDate = "2021-01-01T00:00:00",
      toDate = "2021-02-01T00:00:00",
      scope = "edi",
      env = "staging"
    ),
    "Authentication token not found"
  )
})
