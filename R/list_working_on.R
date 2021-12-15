#' List working on
#'
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) The set of data packages the EDI repository is currently working on inserting or updating. Note that data packages currently being evaluated by PASTA are not included in the list.
#' 
#' @export
#' 
#' @examples 
#' list_working_on()
#' 
list_working_on <- function(env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/package/workingon/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
