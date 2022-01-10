#' Is authorized to read
#'
#' @param resourceId (character) Resource identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (logical) TRUE if the authenticated user has permission to read the
#' specified resource
#'
#' @note User authentication is required (see \code{login()})
#' 
#' @family Miscellaneous
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' login()
#'
#' # Get the most recently created data package
#' auditReport <- get_recent_uploads(
#'   query = "serviceMethod=createDataPackage&limit=1"
#' )
#'
#' # Get the resourceId
#' resourceId <- xml2::xml_text(
#'   xml2::xml_find_all(auditReport, ".//resourceId")
#' )
#' resourceId
#' #> [1] "https://pasta.lternet.edu/package/eml/knb-lter-hbr/345/1"
#'
#' # Check read authorization
#' is_authorized(resourceId)
#' #> [1] TRUE
#'
#' logout()
#' }
#'
is_authorized <- function(resourceId, env = "production") {
  url <- paste0(
    base_url(env), "/package/authz?resourceId=",
    resourceId
  )
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
