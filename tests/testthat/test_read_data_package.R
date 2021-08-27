context("Read data package")

testthat::test_that("Test attributes of returned object", {
  # Standard output
  res <- read_data_package("knb-lter-cwt.5026.13")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
  # ORE output
  res <- read_data_package("knb-lter-cwt.5026.13", ore = TRUE)
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("Description" %in% xml2::xml_name(xml2::xml_children(res)))
})