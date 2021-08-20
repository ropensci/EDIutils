#' List data package citations
#'
#' @description List Data Package Citations operation, specifying the data package scope, identifier, and revision values to match in the URI. Returns a list of journal citations as an XML metadata document.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('XMLInternalDocument' 'XMLAbstractDocument') journalCitations metadata
#' @details GET : https://pasta.lternet.edu/package/citations/eml/{scope}/{identifier}/{revision}
#' @export
#' @examples 
#' # Using curl to access the list of journal citations for the data package with package ID “edi.1000.1”
#'
list_data_package_citations <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving journal citations for package', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/citations/eml/',
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
