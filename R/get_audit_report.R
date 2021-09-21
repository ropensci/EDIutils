#' Get audit report
#'
#' @param query (character) Audit report query (see details below)
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) An XML list of zero or more audit records matching the query parameters as specified in the request.
#' 
#' @details Query parameters:
#' \itemize{
#'   \item category - Can be: "debug", "info", "error", "warn"
#'   \item service - Any of the EDI Data Repository services
#'   \item serviceMethod - Any of the EDI Data Repository service Resource class JAX-RS methods
#'   \item user - Any user
#'   \item group - Any group
#'   \item authSystem - A valid auth system identifier
#'   \item status - A valid HTTP Response Code
#'   \item resourceId - An EDI Data Repository resource identifier, e.g. https://pasta.lternet.edu/package/eml/knb-lter-and/2719/6, or a thereof (see details below)
#'   \item fromTime - An ISO8601 timestamp
#'   \item toTime - An ISO8601 timestamp
#'   \item limit - A positive whole number
#' }
#' 
#' The query parameters fromTime and optionally toTime should be used to indicate a time span. When toTime is absent, the report will consist of all matching records up to the current time. Either of these parameters may only be used once. The query parameter limit sets an upper limit on the number of audit records returned. For example, "limit=1000". The query parameter resourceId will match any audit log entry whose resourceId value contains the specified string value. Thus, a query parameter of "resourceId=knb-lter-and" will match any audit log entry whose resourceId value contains the substring "knb-lter-and", while a query parameter of "resourceId=knb-lter-and/2719/6" will match any audit log entry whose resourceId value contains the substring "knb-lter-and/2719/6".
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#'
get_audit_report <- function(query, tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  # query <- gsub(pattern = "\"", replacement = "%22", x = query)
  url <- paste0(url_env(tier), ".lternet.edu/audit/report?", query)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
