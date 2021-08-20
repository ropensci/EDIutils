#' List active reservations
#'
#' @description List Active Reservations operation, lists the set of data package identifiers that users have actively reserved in PASTA. Note that data package identifiers that have been successfully uploaded into PASTA are no longer considered active reservations and thus are not included in this list.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ("xml_document" "xml_node") XML containing the the 
#'     data package ID, data package title, and data package URL.
#'
#' @details GET : https://pasta.lternet.edu/package/reservations/eml
#'
#' @export
#' 
#' @examples 
#' # Using curl to list active reservations:
#'
list_active_reservations <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving descendants of data package', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/descendants/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  output <- httr::content(
    r,
    as = 'parsed',
    encoding = 'UTF-8'
  )

  output
  
}
