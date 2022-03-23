#' List active reservations
#'
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) The set of data package identifiers 
#' that users have actively reserved. Note that data package identifiers that 
#' have been successfully uploaded are no longer considered active reservations 
#' and thus are not included in this list.
#' 
#' @family Identifier Reservations
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List reservations
#' reservations <- list_active_reservations()
#' }
list_active_reservations <- function(as = "data.frame", env = "production") {
  url <- paste0(base_url(env), "/package/reservations/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
