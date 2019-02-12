#' Read metadata
#'
#' @description
#'     Read Metadata (EML) operation, specifying the scope, identifier, and 
#'     revision of the EML document to be read in the URI.
#'
#' @usage api_read_metadata(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('xml_document' 'xml_node') EML metadata.
#'     
#'
#' @export
#'

api_read_metadata <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving EML for data package', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/metadata/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  eml <- httr::content(
    r,
    as = 'parsed',
    encoding = 'UTF-8'
  )
  
  eml

}