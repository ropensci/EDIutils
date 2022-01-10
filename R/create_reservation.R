#' Create reservation
#'
#' @description Reserves the next available identifier for the specified scope
#'
#' @param scope (character) Scope of data package
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (numeric) Identifier of reserved data package
#'
#' @note User authentication is required (see \code{login()})
#' 
#' @family Identifier Reservations
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' login()
#'
#' # Create reservation
#' identifier <- create_reservation(scope = "edi", env = "staging")
#' identifier
#' #> [1] 604
#'
#' # Delete reservation
#' delete_reservation(scope = "edi", identifier = identifier, env = "staging")
#' #> [1] 604
#'
#' logout()
#' }
#'
create_reservation <- function(scope, env = "production") {
  url <- paste0(base_url(env), "/package/reservations/eml/", scope)
  cookie <- bake_cookie()
  resp <- httr::POST(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(res))
}
