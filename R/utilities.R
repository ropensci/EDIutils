#' Create authentication cookie for EDI Repository Gatekeeper
#'
#' @return (request) The request object returned by \code{httr::set_cookies()} with the EDI Repository authentication token baked in. Yum!
#'
bake_cookie <- function() {
  token_file <- paste0(tempdir(), "/edi_token.txt")
  if (!file.exists(token_file)) {
    stop("Authentication token not found. Run 'login()' then try again.", 
         call. = FALSE)
  }
  token <- readLines(token_file, encoding = "UTF-8")
  cookie <- httr::set_cookies(`auth-token` = token)
  cookie$options$cookie <- curl::curl_unescape(cookie$options$cookie)
  return(cookie)
}








#' Construct a users distinguished name
#'
#' @param userId (character) PASTA userId
#' @param ou (character) Organizational unit in which \code{userId} belongs. Can be "EDI" or "LTER". All \code{userId} issued after "2020-05-01" have \code{ou = "EDI"}.
#'
#' @return (character) Distinguished name
#' 
#' @export
#' 
#' @examples 
#' create_dn("csmith")
#' 
create_dn <- function(userId, ou = "EDI") {
  ou <- toupper(ou)
  validate_arguments(x = as.list(environment()))
  res <- paste0("uid=", userId, ",o=", ou, ",")
  if (ou == "EDI") {
    res <- paste0(res, "dc=edirepository,dc=org")
  } else {
    res <- paste0(res, "dc=ecoinformatics,dc=org")
  }
  return(res)
}








#' Get the first data package in the staging environment for testing
#' 
#' @return (character) Data package ID of the form "scope.identifier.revision".
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
parse_packageId <- function(package.id) {
  parts <- unlist(strsplit(package.id, ".", fixed = TRUE))
  res <- list(scope = parts[1], id = parts[2], rev = parts[3])
  return(res)
}








#' Parse the evaluate quality report to a character string
#'
#' @param qualityReport (xml_document) Evaluate quality report document
#' @param full (logical) Return the full report if TRUE, otherwise return only warnings and errors.
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return (character) A parsed evaluate quality report
#' 
#' @details A utility function for \code{read_evaluate_report()} and \code{summarize_evalute_report()}
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @noRd
#'
report2char <- function(qualityReport, full = TRUE, env) {
  validate_arguments(x = as.list(environment()))
  xml2::xml_ns_strip(qualityReport)
  
  # A helper for summarizing the report
  parse_summary <- function(qualityReport) {
    status <- xml2::xml_text(xml2::xml_find_all(qualityReport, ".//status"))
    n_valid <- sum(status == "valid")
    n_warn <- sum(status == "warn")
    n_error <- sum(status == "error")
    n_info <- sum(status == "info")
    creation_date <- xml2::xml_text(
      xml2::xml_find_first(qualityReport, ".//creationDate"))
    package_id <- xml2::xml_text(
      xml2::xml_find_first(qualityReport, ".//packageId"))
    res <- paste0(
      "\n===================================================\n",
      " EVALUATION REPORT\n",
      "===================================================\n\n",
      "PackageId: ", package_id, "\n",
      "Report Date/Time: ", creation_date, "\n",
      'Total Quality Checks: ', length(status), '\n',
      'Valid: ', n_valid, '\n',
      'Info: ', n_info, '\n',
      'Warn: ', n_warn, '\n',
      'Error: ', n_error, '\n\n')
    return(res)
  }
  
  # A helper for parsing quality checks
  parse_check <- function(check) {
    parent <- xml2::xml_name(check)
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
        "---------------------------------------------------\n")
    } else {
      header <- paste0(
        "---------------------------------------------------\n",
        " DATASET REPORT\n",
        "---------------------------------------------------\n")
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
set_user_agent <- function() {
  res <- httr::user_agent("https://github.com/EDIorg/EDIutils")
  return(res)
}







#' Skip tests when logged out
#'
#' @details Facilitates testing of functions requiring authentication
#' 
skip_if_logged_out <- function() {
  token_file <- paste0(tempdir(), "/edi_token.txt")
  if (!file.exists(token_file)) {
    skip("Not run when logged out")
  }
}








#' Summarize the evaluate quality report
#' 
#' @param transaction (character) Transaction identifier
#' @param with_exceptions (logical) Convert quality report warnings and errors to R warnings and errors
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (message/warning/error) A message listing the total number of checks resulting in valid, info, warn, and error status. Exceptions are raised if warnings and errors are found and \code{with_exceptions} is TRUE.
#' 
#' @details Get \code{transaction} from \code{evaluate_data_package()}
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' transaction <- evaluate_data_package(path)
#' summarize_evaluate_report(transaction)
#' }
#' 
summarize_evaluate_report <- function(transaction, 
                                      with_exceptions = TRUE, 
                                      env = "production") {
  validate_arguments(x = as.list(environment()))
  qualityReport <- read_evaluate_report(transaction, env = env)
  res <- report2char(qualityReport, full = FALSE, env = env)
  message(res)
  if (with_exceptions) {
    any_warn <- !grepl("Warn: 0", res[1])
    any_error <- !grepl("Error: 0", res[1])
    if (any_warn) {
      warning("One or more quality checks resulted in 'warn'", call. = FALSE)
    }
    if (any_error) {
      stop("One or more quality checks resulted in 'error'", call. = FALSE)
    }
  }
}








#' Convert newline separated text to character vector
#'
#' @param txt (character) New line separated character string returned from \code{httr::content(resp, as = "text", encoding = "UTF-8")}
#'
#' @return (character) \code{txt} converted to character vector
#' 
text2char <- function(txt) {
  res <- read.csv(
    text = txt, 
    as.is = TRUE, 
    colClasses = "character", 
    header = FALSE)[[1]]
  return(res)
}








#' Make URL for PASTA+ environment
#'
#' @description
#'     Create the URL suffix to the PASTA+ environment specified by the
#'     environment argument.
#'
#' @usage url_env(environment)
#'
#' @param environment
#'     (character) Data repository environment to perform the evaluation in.
#'     Can be: 'development', 'staging', 'production'.
#'
url_env <- function(env){
  
  env <- tolower(env)
  if (env == 'development'){
    url_env <- 'https://pasta-d'
  } else if (env == 'staging'){
    url_env <- 'https://pasta-s'
  } else if (env == 'production'){
    url_env <- 'https://pasta'
  }
  
  url_env
  
}
