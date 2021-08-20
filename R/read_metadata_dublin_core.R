#' Read metadata Dublin Core
#'
#' @description Read Metadata (Dublin Core) operation, specifying the scope, identifier, and revision of the Dublin Core metadata to be read in the URI. Revision may be specified as “newest” or “oldest” to retrieve the newest or oldest revision, respectively.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('xml_document' 'xml_node') Dublin Core metadata
#'     
#' @details GET : https://pasta.lternet.edu/package/metadata/dc/{scope}/{identifier}/{revision}
#' @export
#' @examples 
#'
read_metadata_dublin_core <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving Dublin Core metadata for data package', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/metadata/dc/',
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
