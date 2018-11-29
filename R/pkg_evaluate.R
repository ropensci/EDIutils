#' Evaluate data package
#'
#' @description
#'     Evaluate data package against the Environmental Data Initiative metadata
#'     quality checker.
#'
#' @usage pkg_evaluate(path, package.id, environment, user.id, user.pass,
#'     affiliation)
#'
#' @param path
#'     (character) Path to the data package EML file.
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.4').
#' @param environment
#'     (character) Data repository environment to perform the evaluation in.
#'     Can be: 'development', 'staging', 'production'.
#' @param user.id
#'     (character) Identification of user performing the evaluation.
#' @param user.pass
#'     (character) Password corresponding with the user.id argument supplied
#'     above.
#' @param affiliation
#'     (character) Affiliation corresponding with the user.id argument supplied
#'     above. Can be: 'LTER' or 'EDI'.
#'
#' @note
#'     Data described by the EML metadata record must be accessible through a
#'     URL supporting download by the EDI data repository. This URL must be
#'     supplied for each data entity in the "physical" node of the EML (i.e.
#'     //physical/distribution/online/url).
#'
#' @export
#'

pkg_evaluate <- function(path, package.id, environment, user.id, user.pass,
                         affiliation){

  validate_arguments(x = as.list(environment()))

  # Place request
  r <- httr::POST(
    url = paste0(url_env(environment), '.lternet.edu/package/evaluate/eml'),
    config = authenticate(auth_key(user.id, affiliation), user.pass),
    body = upload_file(paste0(path, '/', package.id, '.xml'))
  )

  # Enter polling loop
  if (r$status_code == '202'){
    transaction_id <- content(r, as = 'text', encoding = 'UTF-8')
    while (TRUE){
      Sys.sleep(2)
      r <- httr::GET(
        url = paste0(url_env(environment), '.lternet.edu/package/evaluate/report/eml/',
                     transaction_id),
        config = authenticate(auth_key(user.id, affiliation), user.pass)
      )
      if (r$status_code == '200'){
        r_content <- content(r, type = 'text', encoding = 'UTF-8')
        check_status <- unlist(
          stringr::str_extract_all(r_content, '[:alpha:]+(?=</status>)'))
        check_datetime <- unlist(
          stringr::str_extract_all(
            r_content, '(?<=<creationDate>)[:graph:]+(?=</creationDate>)'))
        n_valid <- as.character(sum(check_status == 'valid'))
        n_warn <- as.character(sum(check_status == 'warn'))
        n_error <- as.character(sum(check_status == 'error'))
        n_info <- as.character(sum(check_status == 'info'))
        message(paste0(
          'EVALUATE RESULTS\n',
          'Package Id: ', package.id, '\n',
          'Was Evaluated: Yes\n',
          'Report: ', paste0(url_env(environment),
                             '.lternet.edu/package/evaluate/report/eml/',
                             transaction_id), '\n',
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
    stop('Error evaluating package.')
  }

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
#' @export
#'

url_env <- function(environment){
  
  environment <- tolower(environment)
  if (environment == 'development'){
    url_env <- 'https://pasta-d'
  } else if (environment == 'staging'){
    url_env <- 'https://pasta-s'
  } else if (environment == 'production'){
    url_env <- 'https://pasta'
  }
  
  url_env
  
}




#' Make authentication key
#'
#' @description
#'     Create user authentication key for PASTA+ operations.
#'
#' @usage auth_key(user.id, affiliation)
#'
#' @param user.id
#'     (character) Identification of user performing the evaluation.
#' @param affiliation
#'     (character) Affiliation corresponding with the user.id argument supplied
#'     above. Can be: 'LTER' or 'EDI'.
#'
#' @export
#'

auth_key <- function(user.id, affiliation){
  
  affiliation <- tolower(affiliation)
  if (affiliation == 'lter'){
    key <- paste0('uid=', user.id, ',o=LTER',
                  ',dc=ecoinformatics,dc=org')
  } else if (affiliation == 'edi'){
    key <- paste0('uid=', user.id, ',o=EDI',
                  ',dc=edirepository,dc=org')
  }
  
  key

}
