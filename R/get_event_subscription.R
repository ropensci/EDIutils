#' Get event subscription
#'
#' @param subscriptionId (numeric) Event subscription identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Subscription metadata
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
#' subscription
#' #> {xml_document}
#' #> <subscriptions>
#' #> [1] <subscription type="eml">\n  <id>21</id>\n  <creator>uid=csmith, ...
#'
#' xml2::xml_find_first(subscriptions, "subscription")
#' #> {xml_node}
#' #> <subscription type="eml">
#' #> [1] <id>21</id>
#' #> [2] <creator>uid=csmith,o=EDI,dc=edirepository,dc=org</creator>
#' #> [3] <packageId>edi.94</packageId>
#' #> [4] <url>https://regan.edirepository.org/ecocom-listener</url>
#'
#' logout()
#' }
#'
get_event_subscription <- function(subscriptionId, env = "production") {
  url <- paste0(
    base_url(env), "/package/event/eml/",
    subscriptionId
  )
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
