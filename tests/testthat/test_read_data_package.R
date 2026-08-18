context("Read data package")

testthat::test_that("read_data_package() works", {
  vcr::use_cassette("read_data_package", {
    pkg <- get_test_package()
    res <- read_data_package(pkg, env = "staging")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})

testthat::test_that("read_data_package(..., ore = TRUE) works", {
  vcr::use_cassette("read_data_package_ore", {
    pkg <- get_test_package()
    res <- read_data_package(pkg, ore = TRUE, env = "staging")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("Description" %in% xml2::xml_name(xml2::xml_children(res)))
})
