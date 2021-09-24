#' Query event subscriptions
#'
#' @param query (character) Query (see details below)
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) a list of the subscriptions whose attributes match those specified in the query string (see details below). If a query string is omitted, all subscriptions in the subscription database will be returned for which the requesting user is authorized to read. If query parameters are included, they are used to filter that set of subscriptions based on their attributes.
#' 
#' @details Query parameters are specified as key=value pairs, multiple pairs must be delimited with ampersands (&), and only a single value should be specified for a particular key. The following query parameter keys are allowed:
#' 
#' \itemize{
#'   \item creator
#'   \item scope
#'   \item identifier
#'   \item revision
#'   \item url
#' }
#' 
#' If a query parameter is specified, and a subscription's respective attribute does not match it, that subscription will not be included in the group of subscriptions returned. If scope, identifier, or revision are used, their values must together constitute a syntactically and semantically correct EML packageId (i.e. "scope.identifier.revision") - either partial or complete. If url is used, its value must not contain ampersands. Therefore, if a subscription's URL contains ampersands, it cannot be filtered based on its URL.
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples
#' query_event_subscriptions()
#'
query_event_subscriptions <- function(query = NULL, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/event/eml?")
  if (!is.null(query)) {
    url <- paste0(url, query)
  }
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  httr::stop_for_status(resp, httr::content(resp, "text", encoding = "UTF-8"))
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}