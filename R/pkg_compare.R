#' Compare most data package revisions
#'
#' @description
#'     Compare the contents of the 2 most recent revisions of a data package 
#'     in the EDI data repository and report differences.
#'
#' @usage pkg_compare(package.id, environment)
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.2').
#' @param environment
#'     (character) Data repository environment containing the package to be
#'     updated. Can be: 'development', 'staging', 'production'.
#'
#' @details 
#'     Comparisons:
#'     \itemize{
#'         \item{Data entity names - Do data entity names match?}
#'         \item{Data table columns - Do data tables contain the same number 
#'         of columns and are column names consistent?}
#'     }
#'
#' @return
#'     If inconsistencies are found, then a warning is returned.
#'
#' @export
#'

pkg_compare <- function(package.id, environment){
  
  validate_arguments(x = as.list(environment()))
  
  # Build scope-identifier
  sid <- stringr::str_remove(package.id, '\\.[:digit:]+$')
  sid <- stringr::str_replace_all(sid, '\\.', '/')
  
  # Place request
  r <- httr::PUT(
    url = paste0(url_env(environment), '.lternet.edu/package/eml/', sid),
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
    stop('Error updating package.')
  }
  
}
