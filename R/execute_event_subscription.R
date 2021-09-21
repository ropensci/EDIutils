#' Execute event subscription
#'
#' @param subscriptionId (numeric) Event subscription ID
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (logical) TRUE if the event subscription was deleted
#'     
#' @details Upon notification, the event manager queries its database for the subscription matching the specified subscriptionId. POST requests are then made (asynchronously) to the matching subscription.
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' packageId <- "knb-lter-vcr.340.1"
#' url <- "https://some.server.org"
#' subscriptionId <- create_event_subscription(packageId, url)
#' execute_event_subscription(subscriptionId)
#' }
#'
execute_event_subscription <- function(subscriptionId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/event/eml/", 
                subscriptionId)
  cookie <- bake_cookie()
  resp <- httr::POST(url, 
                     set_user_agent(), 
                     cookie, 
                     handle = httr::handle(""))
  httr::stop_for_status(resp)
  if (resp$status_code == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}