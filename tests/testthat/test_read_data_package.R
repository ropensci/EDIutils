context("Read data package")

testthat::test_that("Test attributes of returned object", {
  # All
  res <- read_data_package("edi.193.5")
  # Newest
  # Oldest
  # ORE
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("dataDescendant" %in% xml2::xml_name(xml2::xml_children(res)))
  dd_children <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  expect_true(all(c("packageId", "title", "url") %in% dd_children))
})

testthat::test_that('Test for object attributes', {
  
  expect_equal(
    class(
      read_data_package(
        package.id = 'edi.275.1',
        environment = 'production'
      )
    ),
    'character'
  )
  
})
