#' Create authentication cookie for EDI repository Gatekeeper
#'
#' @return (request) The request object returned by \code{httr::set_cookies()}
#' with the EDI repository authentication token baked in. Yum!
#'
#' @noRd
#'
bake_cookie <- function() {
  token <- Sys.getenv("EDI_TOKEN")
  if (token == "") {
    stop("Authentication token not found. Run 'login()' then try again.",
      call. = FALSE
    )
  }
  cookie <- httr::set_cookies(`auth-token` = token)
  cookie$options$cookie <- curl::curl_unescape(cookie$options$cookie)
  return(cookie)
}








#' Construct base URL of the EDI repository web services
#'
#' @param env (character) Data repository environment to perform the evaluation
#' in. Can be: 'development', 'staging', 'production'.
#'
#' @return (character) Base url
#'
#' @noRd
#'
base_url <- function(env) {
  env <- tolower(env)
  if (env == "development") {
    res <- "https://pasta-d.lternet.edu"
  } else if (env == "staging") {
    res <- "https://pasta-s.lternet.edu"
  } else if (env == "production") {
    res <- "https://pasta.lternet.edu"
  }
  return(res)
}








#' Construct base URL of the EDI repository data portal
#'
#' @param env (character) Data repository environment to perform the evaluation
#' in. Can be: 'development', 'staging', 'production'.
#'
#' @return (character) Base url
#'
#' @noRd
#'
base_url_portal <- function(env) {
  env <- tolower(env)
  if (env == "development") {
    res <- "https://portal-d.edirepository.org"
  } else if (env == "staging") {
    res <- "https://portal-s.edirepository.org"
  } else if (env == "production") {
    res <- "https://portal.edirepository.org"
  }
  return(res)
}










#' Set environment variables for testing data package evaluation and upload
#'
#' @description Testing data package evaluation and upload requires a web
#' accessible data entity, EML metadata describing the data entity, and an EDI
#' repository user account. Use of this function presupposes the data entity
#' has been stashed
#'
#' @param userId (character) EDI repository userId
#' @param url (character) URL from which the EDI repository can download the
#' test data.txt entity. This URL cannot contain any redirects.
#'
#' @return Environmental variables \code{EDI_USERID = userId} and
#' \code{EDI_TEST_URL = url}
#'
#' @details The results of this function are used to create a test EML file for
#' create, update, and delete tests.
#'
#' @noRd
#'
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
#'
#' @return (character) Full path to EML file written by this function to
#' \code{path}. Should be \code{tempdir()} if executed in a testthat context.
#'
#' @details Copies "eml.xml" at /inst/extdata, adds the userId, packageId, and
#' URL, then writes to \code{paste0(path, "/", packageId, ".xml)}
#'
#' @noRd
#'
create_test_eml <- function(path, packageId) {
  # Read EML template
  eml <- system.file("extdata", "eml.xml", package = "EDIutils")
  eml <- xml2::read_xml(eml)
  # Add packageId
  xml2::xml_attr(eml, "packageId") <- packageId
  # Add principal
  dn <- create_dn(Sys.getenv("EDI_USERID"))
  principal <- xml2::xml_find_first(eml, ".//principal")
  xml2::xml_text(principal) <- dn
  # Add URL
  url <- xml2::xml_find_first(eml, ".//online/url")
  xml2::xml_text(url) <- Sys.getenv("EDI_TEST_URL")
  # Write file
  xml2::write_xml(eml, paste0(path, "/", packageId, ".xml"))
  dest <- paste0(path, "/", packageId, ".xml")
  return(dest)
}








#' Get the first data package in the staging environment for testing
#'
#' @return (character) Data package ID of the form "scope.identifier.revision".
#'
#' @noRd
#'
get_test_package <- function() {
  id <- list_data_package_identifiers("edi", "staging")[1]
  rev <- list_data_package_revisions("edi", id, "newest", "staging")
  res <- paste(c("edi", id, rev), collapse = ".")
  return(res)
}







#' Parse package ID into scope, identifier, and revision
#'
#' @param package.id (character) Data packageId
#'
#' @return (list) Data package scope, identifier, and revision
#'
#' @noRd
#'
parse_packageId <- function(package.id) {
  parts <- unlist(strsplit(package.id, ".", fixed = TRUE))
  res <- list(scope = parts[1], id = parts[2], rev = parts[3])
  return(res)
}








#' Read data package landing page URL
#'
#' @param packageId (character) Package identifier, of the form
#' "scope.identifier.revision", for the new EML file
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) URL of \code{packageId} landing page in the EDI
#' repository data portal
#'
#' @noRd
#'
read_data_package_landing_page_url <- function(packageId, env = "production") {
  parts <- parse_packageId(packageId)
  res <- paste0(
    base_url_portal(env), "/nis/mapbrowse?scope=", parts$scope,
    "&identifier=", parts$id, "&revision=", parts$rev
  )
  return(res)
}








#' Parse the evaluate quality report to a character string
#'
#' @param qualityReport (xml_document) Evaluate quality report document
#' @param full (logical) Return the full report if TRUE, otherwise return only
#' warnings and errors.
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) A parsed evaluate quality report
#'
#' @details A utility function for \code{read_evaluate_report()} and
#' \code{summarize_evalute_report()}
#'
#' @note User authentication is required (see \code{login()})
#'
#' @noRd
#'
report2char <- function(qualityReport, full = TRUE, env) {
  xml2::xml_ns_strip(qualityReport)

  # A helper for summarizing the report
  parse_summary <- function(qualityReport) {
    status <- xml2::xml_text(xml2::xml_find_all(qualityReport, ".//status"))
    n_valid <- sum(status == "valid")
    n_warn <- sum(status == "warn")
    n_error <- sum(status == "error")
    n_info <- sum(status == "info")
    creation_date <- xml2::xml_text(
      xml2::xml_find_first(qualityReport, ".//creationDate")
    )
    package_id <- xml2::xml_text(
      xml2::xml_find_first(qualityReport, ".//packageId")
    )
    res <- paste0(
      "\n===================================================\n",
      " EVALUATION REPORT\n",
      "===================================================\n\n",
      "PackageId: ", package_id, "\n",
      "Report Date/Time: ", creation_date, "\n",
      "Total Quality Checks: ", length(status), "\n",
      "Valid: ", n_valid, "\n",
      "Info: ", n_info, "\n",
      "Warn: ", n_warn, "\n",
      "Error: ", n_error, "\n\n"
    )
    return(res)
  }

  # A helper for parsing quality checks
  parse_check <- function(check) {
    children <- xml2::xml_children(check)
    nms <- xml2::xml_name(children) # names
    values <- xml2::xml_text(children)
    descs <- paste0(toupper(nms), ": ", values) # descriptions
    res <- paste0(paste(descs, collapse = "\n"), "\n")
    return(res)
  }

  # A helper for parsing reports (dataset & entity)
  parse_report <- function(report) {
    entity_name <- xml2::xml_text(xml2::xml_find_all(report, "entityName"))
    if (length(entity_name) > 0) {
      header <- paste0(
        "---------------------------------------------------\n",
        " ENTITY REPORT: ", entity_name, "\n",
        "---------------------------------------------------\n"
      )
    } else {
      header <- paste0(
        "---------------------------------------------------\n",
        " DATASET REPORT\n",
        "---------------------------------------------------\n"
      )
    }
    checks <- xml2::xml_find_all(report, ".//qualityCheck")
    parsed <- lapply(checks, parse_check)
    if (length(parsed) > 0) {
      res <- paste0(paste(c(header, parsed), collapse = "\n"), "\n")
      return(res)
    } else {
      return("")
    }
  }

  # Summarize, then remove any unwanted nodes
  overview <- parse_summary(qualityReport)
  checks <- xml2::xml_find_all(qualityReport, ".//qualityCheck")
  status <- xml2::xml_find_all(qualityReport, ".//status")
  if (full == FALSE) {
    i <- xml2::xml_text(status) %in% c("warn", "error")
    xml2::xml_remove(checks[!i])
  }

  # Parse reports, combine, and return
  dataset_report <- xml2::xml_find_all(qualityReport, ".//datasetReport")
  dataset_report <- lapply(dataset_report, parse_report)
  entity_reports <- xml2::xml_find_all(qualityReport, ".//entityReport")
  entity_reports <- lapply(entity_reports, parse_report)
  res <- c(overview, dataset_report, entity_reports)
  return(as.character(res))
}








#' Set EDIutils user agent for http requests
#'
#' @return (request) EDIutils user agent
#'
#' @noRd
#'
set_user_agent <- function() {
  res <- httr::user_agent("https://github.com/ropensci/EDIutils")
  return(res)
}







#' Skip tests when logged out
#'
#' @details Facilitates testing of functions requiring authentication
#'
#' @noRd
#'
skip_if_logged_out <- function() {
  if ((Sys.getenv("EDI_TOKEN") != "") & 
      (Sys.getenv("EDI_TOKEN") != "foobar")) {
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
#'
skip_if_missing_eml_config <- function() {
  has_userid <- Sys.getenv("EDI_USERID") != ""
  has_url <- Sys.getenv("EDI_TEST_URL") != ""
  if (has_userid & has_url) {
    return(invisible(TRUE))
  }
  msg <- paste0(
    "Not run when test EML config is missing. Set config with ",
    "'config_test_eml()'."
  )
  testthat::skip(msg)
}









#' Convert newline separated text to character vector
#'
#' @param txt (character) New line separated character string returned from
#' \code{httr::content(resp, as = "text", encoding = "UTF-8")}
#'
#' @return (character) \code{txt} converted to character vector
#'
#' @noRd
#'
text2char <- function(txt) {
  res <- utils::read.csv(
    text = txt,
    as.is = TRUE,
    colClasses = "character",
    header = FALSE
  )[[1]]
  return(res)
}








#' Convert xml to data.frame
#'
#' @param xml (xml_document) XML document returned by \code{xml2::read_xml()}
#'
#' @return (data.frame) \code{xml} as a data.frame
#' 
#' @note Only supports XML documents with one or two layers of nesting.
#' 
#' @noRd
#' 
xml2df <- function(xml) {
  node2df <- function(x) {
    chldrn <- xml2::xml_children(x)
    nms <- xml2::xml_name(chldrn, )
    vals <- xml2::xml_text(chldrn)
    names(vals) <- nms
    res <- data.frame(as.list(vals))
    return(res)
  }
  is_nested <- any(xml2::xml_length(xml2::xml_children(xml)) > 0)
  if (is_nested) {
    chldrn <- xml2::xml_children(xml)
    lst <- lapply(chldrn, node2df)
    res <- do.call("rbind", lst)
  } else {
    res <- node2df(xml)
  }
  return(res)
}
