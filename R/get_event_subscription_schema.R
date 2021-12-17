#' Get event subscription schema
#'
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Schema for event subscription creation request entities
#' 
#' @export
#' 
#' @examples 
#' # Get schema
#' schema <- get_event_subscription_schema()
#' schema
#' 
#' # Show schema structure
#' xml2::xml_structure(schema)
#'
get_event_subscription_schema <- function(env = "production") {
  url <- paste0(base_url(env), "/package/event/eml/schema")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
