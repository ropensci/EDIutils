#' Get event subscription
#'
#' @param subscriptionId (numeric) Event subscription identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Subscription metadata
#'
#' @note User authentication is required (see \code{login()})
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
#' # Get subscription
#' subscription <- get_event_subscription(
#'   subscriptionId = 21,
#'   env = "staging"
#' )
#'
#' logout()
#' }
#'
get_event_subscription <- function(subscriptionId, 
                                   as = "data.frame", 
                                   env = "production") {
  url <- paste0(
    base_url(env), "/package/event/eml/",
    subscriptionId
  )
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
