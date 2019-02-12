#' Read metadata resource metadata
#'
#' @description
#'     Read Metadata Resource Metadata operation, specifying the scope, 
#'     identifier, and revision of the data package metadata whose resource
#'     metadata is to be read in the URI.
#'
#' @usage api_read_metadata_resource_metadata(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('xml_document' 'xml_node') An XML string representing 
#'     the resource metadata for the data package metadata resource.
#'     
#'
#' @export
#'

api_read_metadata_resource_metadata <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving metadata resource metadata for ', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/metadata/rmd/eml/',
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