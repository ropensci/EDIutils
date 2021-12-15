context("Get event subscription")

testthat::test_that("Test attributes of returned object", {
  skip_if_logged_out()
  packageId <- get_test_package()
  url <- "https://some.server.org"
  subscriptionId <- create_event_subscription(packageId, url, env = "staging")
  on.exit(delete_event_subscription(subscriptionId, env = "staging"))
  res <- get_event_subscription(subscriptionId, "staging")
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("subscription" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("id", "creator", "packageId", "url")
  expect_true(all(children_found %in% children_expected))
})

#' packageId <- "knb-lter-vcr.340.1"
#' url <- "https://some.server.org"
#' subscriptionId <- create_event_subscription(packageId, url)
#' get_event_subscription(subscriptionId)
