context("List active reservations")

testthat::test_that("list_active_reservations() works", {
  vcr::use_cassette("list_active_reservations", {
    res <- list_active_reservations("staging", as = "xml")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("reservation" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(
    xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("docid", "principal", "dateReserved")
  expect_true(all(children_found %in% children_expected))
})
