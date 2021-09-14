#' Get event subscription schema
#'
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) Schema for event subscription creation request entities
#' 
#' @export
#' 
#' @examples 
#' get_event_subscription_schema()
#'
get_event_subscription_schema <- function(tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/event/eml/schema")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}