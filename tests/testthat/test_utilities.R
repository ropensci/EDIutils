context('Utility functions')

testthat::test_that('PASTA URLs are valid', {
  # development
  expect_equal(base_url('development'), 'https://pasta-d.lternet.edu')
  # staging
  expect_equal(base_url('staging'), 'https://pasta-s.lternet.edu')
  # production
  expect_equal(base_url('production'), 'https://pasta.lternet.edu')
})




testthat::test_that('Portal URLs are valid', {
  # development
  expect_equal(
    base_url_portal('development'), 'https://portal-d.edirepository.org')
  # staging
  expect_equal(
    base_url_portal('staging'), 'https://portal-s.edirepository.org')
  # production
  expect_equal(
    base_url_portal('production'), 'https://portal.edirepository.org')
})




testthat::test_that('Landing page URLs are constructed', {
  res <- read_data_package_landing_page_url("edi.100.1")
  expect_true(class(res) == "character")
})




testthat::test_that("bake_cookie() works", {
  token <- Sys.getenv("EDI_TOKEN")
  Sys.setenv(EDI_TOKEN = "foobar")
  res <- bake_cookie()
  expect_equal(class(res), "request")
  Sys.setenv(EDI_TOKEN = token)
})



testthat::test_that("create_test_eml() works", {
  path <- create_test_eml(tempdir(), "edi.1.1")
  expect_true(file.exists(path))
})



testthat::test_that("parsePackageId() works", {
  res <- parse_packageId("edi.1.1")
  expect_equal(res$scope, "edi")
  expect_equal(res$id, "1")
  expect_equal(res$rev, "1")
})



testthat::test_that("report2char() works", {
  transaction <- "evaluate_163966785813042760"
  vcr::use_cassette("report2char", {
    qualityReport <- read_evaluate_report(transaction, env = "staging")
  })
  res <- report2char(qualityReport, env = "staging")
  expect_true(class(res) == "character")
})



testthat::test_that("set_user_agent() works", {
  res <- set_user_agent()
  expect_equal(class(res), "request")
})



testthat::test_that("text2char() works", {
  res <- text2char("text\ntext\n")
  expect_length(res, 2)
})



testthat::test_that("xml2df() works", {
  # One level of nesting
  vcr::use_cassette("read_data_package_report_resource_metadata", {
    resourceMetadata <- read_data_package_report_resource_metadata(
      packageId = "knb-lter-mcm.9129.3", 
      as = "xml"
    )
  })
  res <- xml2df(resourceMetadata)
  expect_equal(class(res), "data.frame")
  # Two levels of nesting
  vcr::use_cassette("list_data_descendants", {
    dataDescendants <- list_data_descendants("knb-lter-bnz.501.17", as = "xml")
  })
  res <- xml2df(dataDescendants)
  expect_equal(class(res), "data.frame")
})
