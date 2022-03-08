#' Get audit record
#'
#' @param oid (numeric) Audit identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) An audit record
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
#' # Get audit report
#' auditReport <- get_audit_record(oid = "121606334")
#'
#' logout()
#' }
#'
get_audit_record <- function(oid, as = "data.frame", env = "production") {
  url <- paste0(base_url(env), "/audit/report/", oid)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
