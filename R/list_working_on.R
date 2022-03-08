#' List working on
#'
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) The set of data packages the EDI 
#' repository is currently working on inserting or updating. Note that data 
#' packages currently being evaluated by the EDI repository are not included in 
#' the list.
#' 
#' @family System Monitoring
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' list_working_on()
#' }
list_working_on <- function(as = "data.frame", env = "production") {
  url <- paste0(base_url(env), "/package/workingon/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
