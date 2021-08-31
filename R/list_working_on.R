#' List working on
#'
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) The set of data packages the EDI repository is currently working on inserting or updating. Note that data packages currently being evaluated by PASTA are not included in the list.
#' 
#' @export
#' 
#' @examples 
#' list_working_on()
#' 
list_working_on <- function(tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/workingon/eml")
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
