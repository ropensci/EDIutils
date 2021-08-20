#' Read metadata checksum
#'
#' @description Read Metadata Checksum operation, specifying the scope, identifier, and revision of the metadata object whose checksum value is to be read in the URI, returning a 40 character SHA-1 checksum value.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data package report checksum
#' @details GET : https://pasta.lternet.edu/package/metadata/checksum/eml/{scope}/{identifier}/{revision}
#' @export
#' @examples 
#'
read_metadata_checksum <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving metadata checksum for', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/metadata/checksum/eml/',
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
