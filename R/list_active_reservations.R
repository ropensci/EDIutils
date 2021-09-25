#' List active reservations
#'
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) The set of data package identifiers that users have actively reserved. Note that data package identifiers that have been successfully uploaded are no longer considered active reservations and thus are not included in this list.
#'
#' @export
#' 
#' @examples 
#' list_active_reservations()
#'
list_active_reservations <- function(tier = "production"){
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/reservations/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
