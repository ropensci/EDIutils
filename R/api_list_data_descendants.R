#' List data descendants
#'
#' @description
#'     List Data Descendants operation, specifying the scope, identifier, 
#'     and revision values to match in the URI. Data descendants are data 
#'     packages that are known to be derived, in whole or in part, from 
#'     the specified source data package.
#'
#' @usage api_pkg_data_descendants(package.id, environment = 'production')
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
#' @export
#'

api_list_data_descendants <- function(package.id, environment = 'production'){
  
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