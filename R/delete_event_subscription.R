#' Delete event subscription
#'
#' @param subscriptionId (numeric) Event subscription ID
#' @param packageId (character) Data package identifier
#' 
#' @return (logical) TRUE if the event subscription was deleted
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @details After "deletion", the subscription might still exist in the subscription database, but it will be inactive - it will not conflict with future creation requests, it cannot be read, and it will not be notified of events.
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' 
#' }
#'
delete_event_subscription <- function(subscriptionId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/event/eml", "/",
                subscriptionId)
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
