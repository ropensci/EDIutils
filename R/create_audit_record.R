#' Create audit record
#'
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @return New logged entry in the Audit Manager’s logging database
#'
#' @export
#' 
#' @examples 
#'
create_audit_record <- function(tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/audit")
  cookie <- bake_cookie()
  resp <- httr::POST(url, set_user_agent(), cookie, handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  return(as.numeric(parsed))
}
