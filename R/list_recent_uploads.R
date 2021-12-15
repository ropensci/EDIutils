#' List recent uploads
#'
#' @param type (character) Upload type. Can be: "insert" or "update".
#' @param limit (numeric) Maximum number of results to return
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Data package uploads
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
list_recent_uploads <- function(type, limit = 5, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/package/uploads/eml", 
                "?type=", type, "&limit=", limit)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
