#' List reservation identifiers
#' 
#' @param scope (character) Scope of data package (i.e. the first component of a \code{packageId})
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (numeric) The set of identifiers for the specified scope that end users have actively reserved for future upload
#' 
#' @export
#' 
#' @examples 
#' list_reservation_identifiers("edi")
#'
list_reservation_identifiers <- function(scope, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/reservations/eml/", scope)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
