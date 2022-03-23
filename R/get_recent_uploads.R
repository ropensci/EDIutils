#' Get recent uploads
#'
#' @param query (character) Query (see details below)
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) A list of zero or more audit records 
#' of either recently inserted or recently updated data packages.
#'
#' @details Query parameters are specified as key=value pairs, multiple pairs
#' must be delimited with ampersands (&), and only a single value should be
#' specified for a particular key. The following query parameter keys are
#' allowed:
#'
#' \itemize{
#'   \item serviceMethod - Can be: createDataPackage, updateDataPackage
#'   \item fromTime - An ISO8601 timestamp
#'   \item limit - A positive whole number
#' }
#'
#' The query parameter serviceMethod should have the value "createDataPackage"
#' (to retrieve recent inserts) or "updateDataPackage" (to retrieve recent
#' updates). The query parameter fromTime is used to specify the date/time in
#' the past that represents the oldest audit records that should be returned.
#' Data packages uploaded prior to that time are not considered recent uploads
#' and are thus filtered from the query results. The query parameter limit sets
#' an upper limit on the number of audit records returned. For example,
#' "limit=3".
#' 
#' @family Audit Manager Services
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get the 5 most recently created data packages
#' auditReport <- get_recent_uploads(
#'  query = "serviceMethod=createDataPackage&limit=5"
#' )
#' }
get_recent_uploads <- function(query, as = "data.frame", env = "production") {
  url <- paste0(base_url(env), "/audit/recent-uploads?")
  if (!is.null(query)) {
    url <- paste0(url, query)
  }
  resp <- httr::GET(
    url,
    set_user_agent(),
    handle = httr::handle("")
  )
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
