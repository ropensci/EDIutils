#' Read data entity
#'
#' @description Read Data Entity ACL operation, specifying the scope, identifier, revision, and entity identifier of the data entity object whose Access Control List (ACL) is to be read in the URI, returning an XML string representing the ACL for the data entity. Please note: only a very limited set of users are authorized to use this service method.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param identifier
#'     (character) Data entity identifier (e.g. 
#'     5c224a0e74547b14006272064dc869b1)
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data entity checksum
#' @details GET : https://pasta.lternet.edu/package/data/acl/eml/{scope}/{identifier}/{revision}/{entityId}
#' @export
#' @examples 
#'
read_data_entity_acl <- function(package.id, identifier, environment = 'production'){
  
  # TODO implement
  
  message(paste('Retrieving checksum for', package.id, identifier))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/data/checksum/eml/',
      stringr::str_replace_all(package.id, '\\.', '/'),
      '/',
      identifier
    )
  )
  
  r <- httr::content(
    r,
    as = 'text',
    encoding = 'UTF-8'
  )
  
  output <- as.character(
    read.csv(
      text = c(
        'identifier',
        r
      ),
      as.is = T
    )$identifier
  )
  
  output
  
}