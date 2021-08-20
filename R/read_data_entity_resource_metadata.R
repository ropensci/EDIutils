#' Read data entity resource metadata
#'
#' @description Read Data Entity Resource Metadata operation, specifying the scope, identifier, revision, and entity identifier of the data entity object whose resource metadata is to be read in the URI, returning an XML string representing the resource metadata for the data entity.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param entity.id
#'     (character) Data entity identifier (e.g. 
#'     "2353ac38985edd6aff140e4c65cb32de")
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('xml_document' 'xml_node') An XML string representing 
#'     the resource metadata for the data entity.
#' @details GET : https://pasta.lternet.edu/package/data/rmd/eml/{scope}/{identifier}/{revision}/{entityId}
#' @export
#' @examples 
#'
read_data_entity_resource_metadata <- function(package.id, entity.id, 
                                              environment = 'production'){
  
  message(
    paste(
      'Retrieving resource metadata for data entity', 
      entity.id, 
      'from data package', 
      package.id
    )
  )
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/data/rmd/eml/',
      stringr::str_replace_all(package.id, '\\.', '/'),
      '/',
      entity.id
    )
  )
  
  metadata <- httr::content(
    r,
    as = 'parsed',
    encoding = 'UTF-8'
  )
  
  metadata
  
}
