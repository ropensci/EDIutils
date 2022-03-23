#' Get audit report
#'
#' @param query (character) Query (see details below)
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Zero or more audit records matching
#' the query parameters as specified in the request (see details below).
#'
#' @details Query parameters are specified as key=value pairs, multiple pairs
#' must be delimited with ampersands (&), and only a single value should be
#' specified for a particular key. The following query parameter keys are
#' allowed:
#'
#' \itemize{
#'   \item category - Can be: debug, info, error, warn
#'   \item service - Any of the EDI data repository services
#'   \item serviceMethod - Any of the EDI data repository service Resource
#'   class JAX-RS methods
#'   \item user - Any user
#'   \item group - Any group
#'   \item authSystem - A valid auth system identifier
#'   \item status - A valid HTTP Response Code
#'   \item resourceId - An EDI data repository resource identifier, e.g.
#'   https://pasta.lternet.edu/package/eml/knb-lter-and/2719/6, or a thereof
#'   (see details below)
#'   \item fromTime - An ISO8601 timestamp
#'   \item toTime - An ISO8601 timestamp
#'   \item limit - A positive whole number
#' }
#'
#' The query parameters fromTime and optionally toTime should be used to
#' indicate a time span. When toTime is absent, the report will consist of all
#' matching records up to the current time. Either of these parameters may only
#' be used once. The query parameter limit sets an upper limit on the number of
#' audit records returned. For example, "limit=1000". The query parameter
#' resourceId will match any audit log entry whose resourceId value contains
#' the specified string value. Thus, a query parameter of
#' "resourceId=knb-lter-and" will match any audit log entry whose resourceId
#' value contains the substring "knb-lter-and", while a query parameter of
#' "resourceId=knb-lter-and/2719/6" will match any audit log entry whose
#' resourceId value contains the substring "knb-lter-and/2719/6".
#'
#' @note User authentication is required (see \code{login()})
#' 
#' @family Audit Manager Services
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' login()
#'
#' # Get audit report for data reads between 2021-12-01 and 2021-12-02
#' query <- "serviceMethod=readDataEntity&fromTime=2021-12-01&toTime=2021-12-02"
#' auditReport <- get_audit_report(query)
#'
#' logout()
#' }
#'
get_audit_report <- function(query, as = "data.frame", env = "production") {
  url <- paste0(base_url(env), "/audit/report?", query)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
