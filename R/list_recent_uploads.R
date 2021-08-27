#' List recent uploads
#'
#' @param type (character) Upload type, which can be: "insert" or "update"
#' @param limit (numeric) Limit on return values
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) Data package uploads and their packageId, scope, identifier, revision, principal, doi, serviceMethod, and date.
#' 
#' @export
#' 
#' @examples 
#' # Get the 5 newest data packages
#' list_recent_uploads("insert", 3)
#' 
#' # Get the 5 newest revisions
#' list_recent_uploads("update", 3)
#'
list_recent_uploads <- function(type, limit = 5, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/uploads/eml", 
                "?type=", type, "&limit=", limit)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
