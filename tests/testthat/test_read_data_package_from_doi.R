context("Read data package from DOI")

testthat::test_that("Test attributes of returned object", {
  # Standard output
  res <- read_data_package_from_doi("doi:10.6073/pasta/b202c11db7c64943f6b4ed9f8c17fb25")
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
  # ORE output
  res <- read_data_package_from_doi("doi:10.6073/pasta/b202c11db7c64943f6b4ed9f8c17fb25", ore = TRUE)
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("Description" %in% xml2::xml_name(xml2::xml_children(res)))
})
