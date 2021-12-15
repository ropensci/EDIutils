#' Delete reservation
#'
#' @param scope (character) Scope of data package
#' @param identifier (numeric) Identifier of data package
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
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
delete_reservation <- function(scope, identifier, env = "production") {
  url <- paste0(base_url(env), "/package/reservations/eml/", scope,
                "/", identifier)
  cookie <- bake_cookie()
  resp <- httr::DELETE(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(res))
}
