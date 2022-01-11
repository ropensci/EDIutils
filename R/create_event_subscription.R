#' Create event subscription
#'
#' @param packageId (character) Data package identifier
#' @param url (character) Where the event notification will be sent
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (numeric) Event subscription identifier
#'
#' @note User authentication is required (see \code{login()})
#'
#' The \code{url} must have "http" as its scheme and must be able to receive
#' POST requests with MIME type text/plain. Additionally, because the
#' \code{url} will be passed in an XML body, some characters must be escaped,
#' such as ampersands from & to &amp;.
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
#' # Create subscription
#' subscriptionId <- create_event_subscription(
#'   packageId = "knb-lter-vcr.340.1",
#'   url = "https://my.webserver.org/",
#'   env = "staging"
#' )
#' subscriptionId
#' #> [1] 48
#'
#' # Execute subscription
#' execute_event_subscription(subscriptionId, env = "staging")
#' #> [1] TRUE
#'
#' # Delete subscription
#' delete_event_subscription(subscriptionId, env = "staging")
#' #> [1] TRUE
#'
#' logout()
#' }
#'
create_event_subscription <- function(packageId, url, env = "production") {
  subscription <- xml2::xml_new_document()
  xml2::xml_add_child(subscription, "subscription", type = "eml")
  xml2::xml_add_child(subscription, "packageId", packageId)
  xml2::xml_add_child(subscription, "url", url)
  fsub <- paste0(tempdir(), "/payload.xml")
  xml2::write_xml(subscription, fsub)
  on.exit(file.remove(fsub))
  url <- paste0(base_url(env), "/package/event/eml")
  cookie <- bake_cookie()
  resp <- httr::POST(
    url,
    set_user_agent(),
    cookie,
    body = httr::upload_file(fsub),
    handle = httr::handle("")
  )
  msg <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, msg)
  parsed <- unlist(strsplit(resp$headers$location, split = "/"))
  res <- parsed[length(parsed)]
  return(as.numeric(res))
}
