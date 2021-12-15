#' Get recent uploads
#'
#' @param query (character) Query (see details below)
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) A list of zero or more audit records of either recently inserted or recently updated data packages.
#' 
#' @details Query parameters are specified as key=value pairs, multiple pairs must be delimited with ampersands (&), and only a single value should be specified for a particular key. The following query parameter keys are allowed:
#' 
#' \itemize{
#'   \item serviceMethod - Can be: createDataPackage, updateDataPackage
#'   \item fromTime - An ISO8601 timestamp
#'   \item limit - A positive whole number
#' }
#' 
#' The query parameter serviceMethod should have the value "createDataPackage" (to retrieve recent inserts) or "updateDataPackage" (to retrieve recent updates). The query parameter fromTime is used to specify the date/time in the past that represents the oldest audit records that should be returned. Data packages uploaded prior to that time are not considered recent uploads and are thus filtered from the query results. The query parameter limit sets an upper limit on the number of audit records returned. For example, "limit=3".
#' 
#' @export
#' 
#' @examples 
#' query <- "serviceMethod=createDataPackage&limit=5"
#' get_recent_uploads(query)
#'
get_recent_uploads <- function(query, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/audit/recent-uploads?")
  if (!is.null(query)) {
    url <- paste0(url, query)
  }
  resp <- httr::GET(url, 
                    set_user_agent(), 
                    handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
