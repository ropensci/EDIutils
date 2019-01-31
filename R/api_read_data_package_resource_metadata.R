#' Read data package resource metadata
#'
#' @description
#'     Read Data Package Resource Metadata operation, specifying the scope, 
#'     identifier, and revision of the data package whose resource metadata is 
#'     to be read in the URI.
#'
#' @usage api_read_data_package_resource_metadata(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('XMLInternalDocument' 'XMLAbstractDocument') The resource metadata for 
#'     the data package.
#'
#' @export
#'

api_read_data_package_resource_metadata <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving resource metadat for ', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/rmd/eml/',
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