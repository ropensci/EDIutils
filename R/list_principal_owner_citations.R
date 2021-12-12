#' List principal owner citations
#'
#' @param principalOwner (character) Principal owner in the format returned by \code{construct_dn()}
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Journal citations metadata for all entries owned by the specified principal owner
#' 
#' @export
#' 
#' @examples 
#' principalOwner <- create_dn("csmith")
#' list_principal_owner_citations(principalOwner)
#'
list_principal_owner_citations <- function(principalOwner, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/citations/eml/", 
                principalOwner)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
