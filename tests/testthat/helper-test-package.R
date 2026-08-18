# Test Helper Functions for EDIutils
# These helpers are automatically loaded by testthat before running tests.

#' Set environment variables for testing data package evaluation and upload
#'
#' @param userId (character) EDI repository userId
#' @param url (character) URL from which the EDI repository can download the
#' test data.txt entity. This URL cannot contain any redirects.
#'
#' @return Environmental variables \code{EDI_USERID = userId} and
#' \code{EDI_TEST_URL = url}
#'
#' @noRd
config_test_eml <- function(userId, url) {
  Sys.setenv(EDI_USERID = userId)
  Sys.setenv(EDI_TEST_URL = url)
}


#' Create an EML file for testing create, update, delete operations
#'
#' @param path (character) Path to directory in which the test EML will be
#' written to file
#' @param packageId (character) Package identifier, of the form
#' "scope.identifier.revision", for the new EML file
#' @param edi_id (character) The EDI ID of the user creating the test EML.
#'
#' @return (character) Full path to EML file written by this function to
#' \code{path}. Should be \code{tempdir()} if executed in a testthat context.
#'
#' @noRd
create_test_eml <- function(path, packageId, edi_id) {
  # Read EML template
  eml <- system.file("extdata", "eml.xml", package = "EDIutils")
  eml <- xml2::read_xml(eml)
  # Add packageId
  xml2::xml_attr(eml, "packageId") <- packageId
  # Add principal
  principal <- xml2::xml_find_first(eml, ".//principal")
  xml2::xml_text(principal) <- edi_id
  # Add URL
  url <- xml2::xml_find_first(eml, ".//online/url")
  xml2::xml_text(url) <- Sys.getenv("EDI_TEST_URL")
  # Write file
  dest <- paste0(path, "/", packageId, ".xml")
  xml2::write_xml(eml, dest)
  return(dest)
}


#' Get the test data package in the staging environment
#'
#' @return (character) Data package ID of the form "scope.identifier.revision".
#'
#' @noRd
get_test_package <- function() {
  if (tolower(Sys.getenv("VCR_TURN_OFF")) != "true") {
    return("edi.1923.1")
  }
  pkg <- tryCatch({
    revs <- list_data_package_revisions(
      scope = "edi",
      identifier = "1923",
      filter = "newest",
      env = "staging"
    )
    if (length(revs) > 0 && !is.na(revs[1])) {
      paste0("edi.1923.", revs[1])
    } else {
      "edi.1923.1"
    }
  }, error = function(e) {
    "edi.1923.1"
  })
  return(pkg)
}


#' Get a test derived data package ID
#'
#' @return (character) Data package ID of the form "scope.identifier.revision"
#' of a package derived from the test package.
#'
#' @noRd
get_test_derived_package <- function() {
  if (tolower(Sys.getenv("VCR_TURN_OFF")) != "true") {
    return("edi.1932.1")
  }
  pkg <- tryCatch({
    src_pkg <- get_test_package()
    desc <- list_data_descendants(src_pkg, as = "data.frame", env = "staging")
    if (is.data.frame(desc) && nrow(desc) > 0 && nzchar(desc$packageId[1])) {
      desc$packageId[1]
    } else {
      "edi.1932.1"
    }
  }, error = function(e) {
    "edi.1932.1"
  })
  return(pkg)
}


#' Skip tests when logged out
#'
#' @details Facilitates testing of functions requiring authentication
#'
#' @noRd
skip_if_logged_out <- function() {
  has_token <- (Sys.getenv("EDI_TOKEN") != "") && (Sys.getenv("EDI_TOKEN") != "foobar")
  has_key <- (Sys.getenv("EDI_API_KEY") != "") && (Sys.getenv("EDI_API_KEY") != "foobar")
  
  if (has_key && tolower(Sys.getenv("RUN_ALL_TESTS")) != "true") {
    testthat::skip("Skipping computationally heavy authenticated test. Set RUN_ALL_TESTS='true' to run.")
  }
  
  if (has_token || has_key) {
    return(invisible(TRUE))
  }
  testthat::skip("Not run when logged out. Login with 'login()'.")
}


#' Skip tests when EML configuration is missing
#'
#' @details Facilitates testing create, update, and delete for a test data
#' package
#'
#' @noRd
skip_if_missing_eml_config <- function() {
  has_userid <- Sys.getenv("EDI_USERID") != ""
  has_url <- Sys.getenv("EDI_TEST_URL") != ""
  if (has_userid && has_url) {
    return(invisible(TRUE))
  }
  msg <- paste0(
    "Not run when test EML config is missing. Set config with ",
    "'config_test_eml()'."
  )
  testthat::skip(msg)
}
