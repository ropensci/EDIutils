#' List principal owner citations
#'
#' @description List Principal Owner Citations operation, returns journal citations metadata for all entries owned by the specified principal owner.
#'
#' @param dn
#'     (character) Distinguished name (e.g. 
#'     'uid=csmith,o=LTER,dc=ecoinformatics,dc=org')
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('xml_document' 'xml_node') journalCitations metadata
#' @details GET : https://pasta.lternet.edu/package/citations/eml/{principalOwner}
#' @examples 
#' # Using curl to access the list of journal citations owned by user “ucarroll”
#' @export
#'
list_principal_owner_citations <- function(dn, environment = 'production'){
  
  message(paste('Listing journal citations owned by', dn))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/citations/eml/',
      dn
    )
  )
  
  output <- httr::content(
    r,
    as = 'parsed',
    encoding = 'UTF-8'
  )
  
  output
  
}
