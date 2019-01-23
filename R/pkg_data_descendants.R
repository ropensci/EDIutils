#' Get data descendants
#'
#' @description
#'     Get data descendants of a specified parent data package.
#'
#' @usage pkg_data_descendants(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('XMLInternalDocument' 'XMLAbstractDocument') XML containing the the 
#'     data package ID, data package title, and data package URL.
#'
#' @export
#'

pkg_data_descendants <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving descendants of data package', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/descendants/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  output <- XML::xmlParse(
    httr::content(
      r,
      as = 'parsed',
      encoding = 'UTF-8'
    )
  )

  output
  
}