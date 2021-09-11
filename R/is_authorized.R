#' Is authorized
#'
#' @param resourceId (character) Identifier of an EDI Repository resource
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (logical) Whether the user as defined in the authentication token has permission to read the specified data package resource
#'
#' @note User authentication is required (see \code{login()})
#'
#' @export
#' 
#' @examples 
#'
is_authorized <- function(resourceId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/package/authz?resourceId=", 
                resourceId)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  return(as.numeric(parsed))
}
