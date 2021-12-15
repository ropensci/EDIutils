#' Execute event subscription
#'
#' @param subscriptionId (numeric) Event subscription identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (logical) TRUE if the event subscription was executed
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
execute_event_subscription <- function(subscriptionId, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/package/event/eml/", 
                subscriptionId)
  cookie <- bake_cookie()
  resp <- httr::POST(url, 
                     set_user_agent(), 
                     cookie, 
                     handle = httr::handle(""))
  msg <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, msg)
  if (resp$status_code == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
