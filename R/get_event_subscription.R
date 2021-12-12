#' Get event subscription
#'
#' @description Get Event Subscription returns the event subscription with the specified ID.
#'
#' @param subscriptionId (numeric) Event subscription identifier
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Subscription metadata
#' 
#' @export
#' 
#' @examples 
#' packageId <- "knb-lter-vcr.340.1"
#' url <- "https://some.server.org"
#' subscriptionId <- create_event_subscription(packageId, url)
#' get_event_subscription(subscriptionId)
#'
get_event_subscription <- function(subscriptionId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/event/eml/", 
                subscriptionId)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
