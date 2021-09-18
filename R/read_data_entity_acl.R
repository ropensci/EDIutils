#' Read data entity access control list
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param entityId (character) Data entity identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) The access control list for the data entity. Please note: only a very limited set of users are authorized to use this service method.
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#'
read_data_entity_acl <- function(packageId, entityId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/package/data/acl/eml/",
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                entityId)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  httr::stop_for_status(resp)
  browser()
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}