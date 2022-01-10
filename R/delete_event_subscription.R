#' Delete event subscription
#'
#' @param subscriptionId (numeric) Event subscription identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (logical) TRUE if the event subscription was deleted
#'
#' @note User authentication is required (see \code{login()})
#'
#' @details After "deletion", the subscription might still exist in the
#' subscription database, but it will be inactive - it will not conflict with
#' future creation requests, it cannot be read, and it will not be notified of
#' events.
#' 
#' @family Event Notifications
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' login()
#'
#' # Create subscription
#' subscriptionId <- create_event_subscription(
#'   packageId = "knb-lter-vcr.340.1",
#'   url = "https://my.webserver.org/",
#'   env = "staging"
#' )
#' subscriptionId
#' #> [1] 48
#'
#' # Execute subscription
#' execute_event_subscription(
#'   subscriptionId = subscriptionId,
#'   env = "staging"
#' )
#' #> [1] TRUE
#'
#' # Delete subscription
#' delete_event_subscription(subscriptionId, env = "staging")
#' #> [1] TRUE
#'
#' logout()
#' }
#'
delete_event_subscription <- function(subscriptionId, env = "production") {
  url <- paste0(
    base_url(env), "/package/event/eml", "/",
    subscriptionId
  )
  cookie <- bake_cookie()
  resp <- httr::DELETE(url, set_user_agent(), cookie, handle = httr::handle(""))
  msg <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, msg)
  if (resp$status_code == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
