context("Read data package citation")

testthat::test_that("read_data_package_citation() works", {
  packageId <- get_test_package()
  # As char
  vcr::use_cassette("read_data_package_citation", {
    res <- read_data_package_citation(packageId, env = "staging")
  })
  expect_equal(class(res), "character")
  # As html
  vcr::use_cassette("read_data_package_citation_html", {
    res <- read_data_package_citation(packageId, as = "html", env = "staging")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  # As json
  vcr::use_cassette("read_data_package_citation_json", {
    res <- read_data_package_citation(packageId, as = "json", env = "staging")
  })
  expect_equal(class(res), "json")
})
