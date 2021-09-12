#' List data package citations
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) A list of journal citations
#' 
#' @export
#' 
#' @examples 
#' 
#'
list_data_package_citations <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/package/descendants/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
