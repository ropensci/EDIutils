#' Read metadata format
#'
#' @description
#'     Read Metadata Format operation, specifying the scope, identifier, and 
#'     revision of the metadata to be read in the URI.
#'
#' @usage api_read_metadata_format(package.id, environment = 
#'     'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) The metadata format type, e.g. 
#'     “eml://ecoinformatics.org/eml-2.1.1”
#'
#' @export
#'

api_read_metadata_format <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving metadata format for', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/metadata/format/eml/',
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