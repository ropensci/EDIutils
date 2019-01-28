#' List principal owner citations
#'
#' @description
#'     List Principal Owner Citations operation.
#'
#' @usage api_list_principal_owner_citations(dn, environment = 'production')
#'
#' @param dn
#'     (character) Distinguished name (e.g. 
#'     'uid=csmith,o=LTER,dc=ecoinformatics,dc=org')
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('XMLInternalDocument' 'XMLAbstractDocument') journalCitations metadata
#'
#' @export
#'

api_list_principal_owner_citations <- function(dn, environment = 'production'){
  
  message(paste('Listing journal citations owned by', dn))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/citations/eml/',
      dn
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