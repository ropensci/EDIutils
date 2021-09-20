#' Make authentication key
#'
#' @description
#'     Create user authentication key for PASTA+ operations.
#'
#' @param user.id
#'     (character) Identification of user performing the evaluation.
#' @param affiliation
#'     (character) Affiliation corresponding with the user.id argument supplied
#'     above. Can be: 'LTER' or 'EDI'.
#'
auth_key <- function(user.id, affiliation){
  
  affiliation <- tolower(affiliation)
  if (affiliation == 'lter'){
    key <- paste0('uid=', user.id, ',o=LTER',
                  ',dc=edirepository,dc=org')
  } else if (affiliation == 'edi'){
    key <- paste0('uid=', user.id, ',o=EDI',
                  ',dc=edirepository,dc=org')
  }
  
  key
  
}








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








#' Collapse EML node to string then compare
#'
#' @param newest (xml_document, xml_node) Newest version of an EML document
#' @param previous (xml_document, xml_node) Previous version of an EML document
#' @param xpath (character) xpath of node to compare
#'
#' @return (character) xpath of node if \code{newest} and \code{previous} differ, otherwise NULL
#' 
compare_node_as_string <- function(newest, previous, xpath) {
  
  # Collapse to string
  newest <- xml2::xml_text(xml2::xml_find_all(newest, xpath))
  previous <- xml2::xml_text(xml2::xml_find_all(previous, xpath))
  
  # Only return dissimilar nodes. Add node number to xpath for exact reference.
  if (!all(newest == previous)) {
    nodes <- which(!(newest == previous))
    if (stringr::str_detect(xpath, "dataTable")) {
      parts <- stringr::str_split(xpath, "(?<=dataTable)")
      res <- paste0(parts[[1]][1], "[", nodes, "]", parts[[1]][2])
      return(res)
    } else if (stringr::str_detect(xpath, "otherEntity")) {
      parts <- stringr::str_split(xpath, "(?<=otherEntity)")
      res <- paste0(parts[[1]][1], "[", nodes, "]", parts[[1]][2])
      return(res)
    } else {
      res <- xpath
      return(res)
    }
  }
  
}








#' Convert missing value codes to NA
#'
#' @param v Vector of values
#' @param code (character) Missing value code
#' @param type (character) Type (class) \code{v} should be. Supported types are: "character", "numeric", "datetime"
#'
#' @return Vector of values with \code{code} replaced by NA in the class of \code{type}
#'
convert_missing_value <- function(v, code, type) {
  if (type == "character") {
    res <- stringr::str_replace_all(as.character(v), paste(code, collapse = "|"), NA_character_)
  } else if (type == "numeric") {
    res <- stringr::str_replace_all(as.character(v), paste(code, collapse = "|"), NA_character_)
    res <- as.numeric(res)
  } else if (type == "datetime") {
    # TODO: Parse datetime according to date time format specifier
    res <- v
  }
  return(res)
}








#' Construct a users distinguished name
#'
#' @param userId (character) PASTA userId
#' @param ou (character) Organizational unit in which \code{userId} belongs. Can be "EDI" or "LTER".
#'
#' @return (character) Distinguished name
#' 
#' @export
#' 
#' @examples 
#' construct_dn("csmith")
#' 
construct_dn <- function(userId, ou = "EDI") {
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








#' Enter polling loop
#'
#' @param transaction (character) Transaction identifier 
#'
#' @return
#' 
#' @export
#'
#' @examples
#' 
enter_polling_loop <- function(transaction) {
  
  # Place request
  r <- httr::POST(
    url = paste0(url_env(environment), '.lternet.edu/package/evaluate/eml'),
    config = httr::authenticate(auth_key(user.id, affiliation), user.pass),
    body = httr::upload_file(paste0(path, '/', package.id, '.xml'))
  )
  
  
  if (r$status_code == '202') {
    transaction_id <- httr::content(r, as = 'text', encoding = 'UTF-8')
    while (TRUE){
      Sys.sleep(2)
      r <- httr::GET(
        url = paste0(url_env(environment), '.lternet.edu/package/error/eml/',
                     transaction_id),
        config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
      )
      if (r$status_code == '200'){
        r_content <- httr::content(r, type = 'text', encoding = 'UTF-8')
        stop(r_content)
        break
      }
      r <- httr::GET(
        url = paste0(url_env(environment), '.lternet.edu/package/eml/',
                     stringr::str_replace_all(package.id, '\\.', '/')),
        config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
      )
      if (r$status_code == '200'){
        eval_report <- readr::read_file(
          paste0(url_env(environment), '.lternet.edu/package/report/eml/',
                 stringr::str_replace_all(package.id, '\\.', '/'))
        )
        check_status <- unlist(
          stringr::str_extract_all(eval_report, '[:alpha:]+(?=</status>)'))
        check_datetime <- unlist(
          stringr::str_extract_all(
            eval_report, '(?<=<creationDate>)[:graph:]+(?=</creationDate>)'))
        n_valid <- as.character(sum(check_status == 'valid'))
        n_warn <- as.character(sum(check_status == 'warn'))
        n_error <- as.character(sum(check_status == 'error'))
        n_info <- as.character(sum(check_status == 'info'))
        message(paste0(
          'UPLOAD RESULTS\n',
          'Package Id: ', package.id, '\n',
          'Was Uploaded: Yes\n',
          'Report: ', paste0(url_env(environment),
                             '.lternet.edu/package/evaluate/report/eml/',
                             stringr::str_replace_all(package.id, '\\.', '/')),
          '\n',
          'Creation Date:', check_datetime, '\n',
          'Total Quality Checks: ', length(check_status), '\n',
          'Valid: ', n_valid, '\n',
          'Info: ', n_info, '\n',
          'Warn: ', n_warn, '\n',
          'Error: ', n_error, '\n'
        )
        )
        break
      }
    }
  } else {
    stop('Error creating package.')
  }
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







#' Summarize evaluation report
#'
#' @param eval_report (character) Evaluation report XML as a character string
#'
#' @return (character) Summary of evaluation report
#'
summarize_evalutation_report <- function(eval_report) {
  pattern <- "[[:alpha:]]+(?=</status>)"
  check_status <- unlist(
    regmatches(eval_report, gregexpr(pattern, eval_report, perl = TRUE)))
  n_valid <- as.character(sum(check_status == 'valid'))
  n_warn <- as.character(sum(check_status == 'warn'))
  n_error <- as.character(sum(check_status == 'error'))
  n_info <- as.character(sum(check_status == 'info'))
  if (n_error == 0) {
    was_uploaded <- "Yes"
  } else {
    was_uploaded <- "No"
  }
  parsed <- paste0(
    'RESULTS\n',
    'Was Uploaded: ', was_uploaded, '\n',
    'Total Quality Checks: ', length(check_status), '\n',
    'Valid: ', n_valid, '\n',
    'Info: ', n_info, '\n',
    'Warn: ', n_warn, '\n',
    'Error: ', n_error, '\n')
  return(parsed)
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
url_env <- function(tier){
  
  tier <- tolower(tier)
  if (tier == 'development'){
    url_env <- 'https://pasta-d'
  } else if (tier == 'staging'){
    url_env <- 'https://pasta-s'
  } else if (tier == 'production'){
    url_env <- 'https://pasta'
  }
  
  url_env
  
}








#' Convert minimally nested XML to data.frame
#'
#' @param xml (xml_document xml_node) XML with one level of nesting
#' 
#' @return (data.frame) A data.frame of \code{xml}
#' 
xml2df <- function(xml) {
  lst <- xml2::as_list(xml)[[1]]
  df <- data.frame(
    matrix(unlist(lst), ncol = max(lengths(lst)), byrow = TRUE))
  names(df) <- names(lst[[which(lengths(lst) > 0)[1]]])
  return(df)
}