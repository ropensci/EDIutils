#' Get provenance metadata
#'
#' @description
#'     Add Provenance Metadata from Level-1 metadata in PASTA to an XML 
#'     document containing a single methods element in the request message 
#'     body.
#'
#' @usage get_provenance_metadata(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('XMLInternalDocument' 'XMLAbstractDocument') EML metadata.
#'     
#'
#' @export
#'

get_provenance_metadata <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving provenance metadata for ', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/provenance/eml/',
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