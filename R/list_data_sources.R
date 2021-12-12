#' List data sources
#'
#' @description Data sources are data packages, or other online digital objects, that are known to be inputs to the specified derived data package.
#'
#' @param packageId (character) Data package identifier
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Data sources to \code{packageId} including their data package identifier, title, and url
#'
#' @export
#'
#' @examples 
#' list_data_sources("edi.275.4")
#'
list_data_sources <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  parts <- parse_packageId(packageId)
  url <- paste0(url_env(tier), ".lternet.edu/package/sources/eml/", 
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
