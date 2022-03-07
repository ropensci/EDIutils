#' Get audit record
#'
#' @param oid (numeric) Audit identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) An audit record with fields
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
#' auditReport
#' #> {xml_document}
#' #> <auditReport>
#' #>  [1] <auditRecord>\n  <oid>121606334</oid>\n  <entryTime>2021-12-01T ...
#'
#' xml2::xml_find_first(auditReport, ".//auditRecord")
#' #> {xml_node}
#' #> <auditRecord>
#' #>  [1] <oid>121606334</oid>
#' #>  [2] <entryTime>2021-12-01T00:00:07</entryTime>
#' #>  [3] <category>warn</category>
#' #>  [4] <service>DataPackageManager-1.0</service>
#' #>  [5] <serviceMethod>readDataEntity</serviceMethod>
#' #>  [6] <responseStatus>401</responseStatus>
#' #>  [7] <resourceId/>
#' #>  [8] <user>robot</user>
#' #>  [9] <userAgent>Mozilla/5.0 (compatible; SemrushBot/7~bl; +http://ww ...
#' #> [10] <groups/>
#' #> [11] <authSystem>https://pasta.edirepository.org/authentication</aut ...
#' #> [12] <entryText>Robots are not authorized access to data objects. Ro ...
#'
#' logout()
#' }
#'
get_audit_record <- function(oid, env = "production") {
  url <- paste0(base_url(env), "/audit/report/", oid)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
