context("Read data package")

testthat::test_that("read_data_package() works", {
  vcr::use_cassette("read_data_package", {
    res <- read_data_package("knb-lter-cwt.5026.13")
  })
  expect_equal(class(res), "character")
  expect_true(length(res) > 0)
})

testthat::test_that("read_data_package(..., ore = TRUE) works", {
  vcr::use_cassette("read_data_package_ore", {
    res <- read_data_package("knb-lter-cwt.5026.13", ore = TRUE)
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("Description" %in% xml2::xml_name(xml2::xml_children(res)))
})
