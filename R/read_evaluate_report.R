#' Read evaluate report
#'
#' @param transaction (character) Transaction identifier returned for each data package evaluate, upload, and delete operation
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' @param html (logical) Return result in HTML format?
#' @param strip_ns (logical) Strip result namespace?
#'
#' @return (xml_document) The evaluate quality report document
#' 
#' @export
#' 
#' @examples 
#'
read_evaluate_report <- function(transaction, tier = "production", 
                                 html = FALSE, strip_ns = TRUE) {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/evaluate/report/eml/",
                transaction)
  if (html) {
    resp <- httr::GET(url, set_user_agent(), httr::accept("text/html"))
    httr::stop_for_status(resp)
    parsed <- xml2::read_html(httr::content(resp, "text", encoding = "UTF-8"))
  } else {
    resp <- httr::GET(url, set_user_agent())
    httr::stop_for_status(resp)
    parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  }
  if (strip_ns) {
    return(xml2::xml_ns_strip(parsed))
  } else {
    return(parsed)
  }
}