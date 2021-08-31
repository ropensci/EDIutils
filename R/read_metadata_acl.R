#' Read metadata Access Control List
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' @param strip_ns (logical) Strip result namespace?
#'
#' @return (xml_document) Metadata ACL resource. Please note: only a very limited set of users are authorized to use this service method.
#' 
#' @export
#' 
#' @examples 
#'
read_metadata_acl <- function(packageId, tier = "production", 
                              strip_ns = TRUE) {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/metadata/acl/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  if (strip_ns) {
    return(xml2::xml_ns_strip(parsed))
  } else {
    return(parsed)
  }
}
