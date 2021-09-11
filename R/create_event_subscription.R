#' Create event subscription
#' 
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @return A new event subscription
#' 
#' @export
#' 
#' @examples 
#'
create_event_subscription <- function(tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/package/event/eml")
  cookie <- bake_cookie()
  resp <- httr::POST(url, set_user_agent(), cookie, handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  return(as.numeric(parsed))
}
