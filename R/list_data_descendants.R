#' List data descendants
#' 
#' @description Data descendants are data packages that are known to be derived, in whole or in part, from the specified source data package.
#' 
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @return (xml_document) Descendants of \code{packageId}, including their packageId, title, and url
#' 
#' @export
#' 
#' @examples 
#' list_data_descendants("knb-lter-bnz.501.17")
#'
list_data_descendants <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/descendants/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}