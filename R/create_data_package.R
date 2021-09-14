#' Create data package
#'
#' @description Creates a new PASTA data package by providing the EML document describing the data package to be created in the request message body and returning a transaction identifier in the response message body as plain text; the transaction identifier may be used in a subsequent call to Read Data Package Error to determine the operation status; see Read Data Package to obtain the data package resource map if the operation completed successfully.
#'
#' @param path
#'     (character) Path to the data package EML file.
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#' @param user.id
#'     (character) Identification of user creating the data package.
#' @param user.pass
#'     (character) Password corresponding with the user.id argument supplied
#'     above.
#' @param affiliation
#'     (character) Affiliation corresponding with the user.id argument supplied
#'     above. Can be: 'LTER' or 'EDI'.
#'     
#' @details POST : https://pasta.lternet.edu/package/eml
#'
#' @export
#' 
#' @examples 
#' Upload a new data package where knb-lter-lno.1.1.xml is the filesystem EML document in XML format
#'
create_data_package <- function(path, package.id, environment, user.id, user.pass,
                       affiliation){

  validate_arguments(x = as.list(environment()))

  # Place request
  r <- httr::POST(
    url = paste0(url_env(environment), '.lternet.edu/package/eml'),
    config = httr::authenticate(auth_key(user.id, affiliation), user.pass),
    body = httr::upload_file(paste0(path, '/', package.id, '.xml'))
  )

  # Enter polling loop
  if (r$status_code == '202'){
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