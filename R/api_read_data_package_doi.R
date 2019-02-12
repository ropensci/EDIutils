#' Read data package DOI
#'
#' @description
#'     Read Data Package DOI operation, specifying the scope, identifier, 
#'     and revision of the data package DOI to be read in the URI.
#'
#' @usage api_read_data_package_doi(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) The canonical Digital Object Identifier.
#'
#' @export
#'

api_read_data_package_doi <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving DOI for', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/doi/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  output <- httr::content(
    r,
    as = 'text',
    encoding = 'UTF-8'
  )
  
  output
  
}