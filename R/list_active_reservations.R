#' List active reservations
#'
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) The set of data package identifiers that users have
#' actively reserved. Note that data package identifiers that have been
#' successfully uploaded are no longer considered active reservations and thus
#' are not included in this list.
#'
#' @export
#'
#' @examples
#' # List reservations
#' reservations <- list_active_reservations()
#' reservations
#'
#' # Show first
#' xml2::xml_find_first(reservations, "reservation")
list_active_reservations <- function(env = "production") {
  url <- paste0(base_url(env), "/package/reservations/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
