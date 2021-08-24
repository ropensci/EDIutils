#' List recent uploads
#'
#' @param type (character) Upload type. Can be: "insert" or "update".
#' @param limit (integer) Maximum limit.
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) packageId, scope, identifier, revision, principal, doi, serviceMethod, and date of data package uploads.
#' 
#' @details GET : https://pasta.lternet.edu/package/uploads/eml
#' 
#' @export
#' 
#' @examples 
#' list_recent_uploads("update", 10)
#'
list_recent_uploads <- function(type, limit = 5, environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/uploads/eml", 
                "?type=", type, "&limit=", limit)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
