#' Get audit record
#' 
#' @param oid (numeric) Audit identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) An audit record
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' query <- "serviceMethod=createDataPackage&limit=5"
#' recent_uploads <- get_recent_uploads(query)
#' oid <- xml2::xml_text(xml2::xml_find_all(recent_uploads, ".//oid"))[1]
#' get_audit_record(oid)
#'
get_audit_record <- function(oid, env = "production") {
  url <- paste0(base_url(env), "/audit/report/", oid)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
