#' List recent uploads
#'
#' @param type (character) Upload type. Can be: "insert" or "update".
#' @param limit (numeric) Maximum number of results to return
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Data package uploads
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get the 3 newest revisions
#' dataPackageUploads <- list_recent_uploads("update", 3)
#' }
list_recent_uploads <- function(type, 
                                limit = 5, 
                                as = "data.frame", 
                                env = "production") {
  url <- paste0(
    base_url(env), "/package/uploads/eml",
    "?type=", type, "&limit=", limit
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
