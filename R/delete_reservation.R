#' Delete reservation
#'
#' @param scope (character) Scope of data package (i.e. the first component of a \code{packageId})
#' @param identifier (numeric) Identifier of data package (i.e. the second component of a \code{packageId})
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @note User authentication is required (see \code{login()}). The same user who originally authenticated to create the reservation must authenticate to delete it.
#'     
#' @return (numeric) The deleted reservation identifier value
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' login()
#' identifier <- create_reservation("edi")
#' delete_reservation("edi", identifier)
#' }
#'
delete_reservation <- function(scope, identifier, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/reservations/eml/", scope,
                "/", identifier)
  cookie <- bake_cookie()
  resp <- httr::DELETE(url, set_user_agent(), cookie, handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  return(as.numeric(parsed))
}