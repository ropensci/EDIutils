#' List data package citations
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' @param list_all (logical) Whether to return all citations within a data package series (i.e. multiple revisions)
#'
#' @return (xml_document) A list of journal citations
#' 
#' @export
#' 
#' @examples 
#' list_data_package_citations("edi.845.1")
#'
list_data_package_citations <- function(packageId, 
                                        tier = "production", 
                                        list_all = FALSE) {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/citations/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  if (list_all) {
    url <- paste0(url, "?all")
  }
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
