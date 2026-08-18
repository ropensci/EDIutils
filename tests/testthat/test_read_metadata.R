context("Read metadata")

testthat::test_that("read_metadata() works", {
  vcr::use_cassette("read_metadata", {
    pkg <- get_test_package()
    res <- read_metadata(pkg, env = "staging")
  })
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true(all(c("access", "dataset") %in% 
                    xml2::xml_name(xml2::xml_children(res))))
})
