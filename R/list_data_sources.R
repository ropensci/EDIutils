#' List data sources
#'
#' @description Data sources can be either internal or external to PASTA. Internal data sources include a "packageId" value and a URL to the source metadata. For data sources external to PASTA, the "packageId" element will be empty and a URL value may or not be documented.
#'
#' @param package.id (character) Package identifier composed of scope, identifier, and revision (e.g. 'edi.101.1').
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) For each data source, its package identifier, title, and URL values are included (if applicable) as documented in the metadata for the specified data package.      
#' 
#' @details GET : https://pasta.lternet.edu/package/sources/eml/{scope}/{identifier}/{revision}
#'
#' @export
#'
#' @examples 
#' list_data_sources("edi.275.4")
#'
list_data_sources <- function(package.id, environment = "production") {
  validate_arguments(x = as.list(environment()))
  parts <- parse_packageId(package.id)
  url <- paste0(url_env(environment), ".lternet.edu/package/sources/eml/", 
                paste(parts, collapse = "/"))
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
