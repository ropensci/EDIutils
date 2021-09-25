#' Is authorized to read
#'
#' @param resourceId (character) Identifier of an EDI Repository resource
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (logical) TRUE if the authenticated user has permission to read the specified resource
#'
#' @note User authentication is required (see \code{login()})
#'
#' @export
#' 
#' @examples 
#' \dontrun{
#' resourceId <- "https://pasta.lternet.edu/package/report/eml/knb-lter-sbc/6006/3"
#' is_authorized(resourceId)
#' }
#'
is_authorized <- function(resourceId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/authz?resourceId=", 
                resourceId)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  if (resp$status_code == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
