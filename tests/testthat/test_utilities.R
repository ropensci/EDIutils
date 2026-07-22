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
  edi_token <- Sys.getenv("EDI_TOKEN")
  Sys.setenv(EDI_TOKEN = "foobar")
  res <- bake_cookie()
  expect_equal(class(res), "request")
  Sys.setenv(EDI_TOKEN = edi_token)
})



testthat::test_that("create_test_eml() works", {
  path <- create_test_eml(
    tempdir(), 
    "edi.1.1", 
    edi_id = "EDI-543afa80c859825d35d37d9111c24a4a65a0db9f"
    )
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



testthat::test_that("add_api_key() works", {
  # Save original key
  orig_key <- Sys.getenv("EDI_API_KEY")
  on.exit(if (orig_key == "") Sys.unsetenv("EDI_API_KEY") else Sys.setenv(EDI_API_KEY = orig_key))
  
  # No key set
  Sys.unsetenv("EDI_API_KEY")
  expect_equal(add_api_key("https://pasta.lternet.edu/package"), "https://pasta.lternet.edu/package")
  
  # Key set, no existing parameters
  Sys.setenv(EDI_API_KEY = "testkey")
  expect_equal(add_api_key("https://pasta.lternet.edu/package"), "https://pasta.lternet.edu/package?key=testkey")
  
  # Key set, existing parameters
  expect_equal(add_api_key("https://pasta.lternet.edu/package?ore"), "https://pasta.lternet.edu/package?ore&key=testkey")
  
  # Key set, key already in URL (should not duplicate)
  expect_equal(add_api_key("https://pasta.lternet.edu/package?key=testkey"), "https://pasta.lternet.edu/package?key=testkey")
})


testthat::test_that("login() and logout() with API key works", {
  # Save original key
  orig_key <- Sys.getenv("EDI_API_KEY")
  on.exit(if (orig_key == "") Sys.unsetenv("EDI_API_KEY") else Sys.setenv(EDI_API_KEY = orig_key))
  
  # Test programmatic login with key
  Sys.unsetenv("EDI_API_KEY")
  login(key = "test_api_key")
  expect_equal(Sys.getenv("EDI_API_KEY"), "test_api_key")
  
  # Test logout unsets key
  logout()
  expect_equal(Sys.getenv("EDI_API_KEY"), "")
})


testthat::test_that("bake_cookie() handles key-only authentication correctly", {
  # Save original environment variables
  orig_token <- Sys.getenv("EDI_TOKEN")
  orig_key <- Sys.getenv("EDI_API_KEY")
  on.exit({
    if (orig_token == "") Sys.unsetenv("EDI_TOKEN") else Sys.setenv(EDI_TOKEN = orig_token)
    if (orig_key == "") Sys.unsetenv("EDI_API_KEY") else Sys.setenv(EDI_API_KEY = orig_key)
  })
  
  # Case 1: EDI_TOKEN is empty, EDI_API_KEY is empty -> expect error
  Sys.unsetenv("EDI_TOKEN")
  Sys.unsetenv("EDI_API_KEY")
  expect_error(bake_cookie(), "Authentication token not found")
  
  # Case 2: EDI_TOKEN is set, EDI_API_KEY is empty -> expect baked cookie
  Sys.setenv(EDI_TOKEN = "mock_token")
  cookie <- bake_cookie()
  expect_s3_class(cookie, "request")
  expect_match(cookie$options$cookie, "edi-token=mock_token")
  
  # Case 3: EDI_TOKEN is empty, EDI_API_KEY is set -> expect empty config (no error)
  Sys.unsetenv("EDI_TOKEN")
  Sys.setenv(EDI_API_KEY = "mock_key")
  config <- bake_cookie()
  expect_s3_class(config, "request")
  expect_null(config$options$cookie)
  
  # Case 4: EDI_TOKEN is 'foobar' (fake), EDI_API_KEY is set (live test run) -> expect empty config
  Sys.setenv(EDI_TOKEN = "foobar")
  Sys.setenv(EDI_API_KEY = "mock_key")
  config <- bake_cookie()
  expect_s3_class(config, "request")
  expect_null(config$options$cookie)
})
