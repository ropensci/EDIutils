#' Create reservation
#'
#' @param scope (character) Scope of data package
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#' 
#' @return (numeric) Identifier of reserved data package (i.e. the second component of a \code{packageId})
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' login()
#' create_reservation("edi")
#' }
#'
create_reservation <- function(scope, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/reservations/eml/", scope)
  cookie <- bake_cookie()
  resp <- httr::POST(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(res))
}