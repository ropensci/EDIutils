#' Read data package report
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' @param html (logical) Return result in HTML format?
#' @param strip_ns (logical) Strip result namespace?
#'
#' @return (xml_document or html) Data package report
#' 
#' @export
#' 
#' @examples 
#' # Result in XML format
#' read_data_package_report("knb-lter-knz.260.4")
#' 
#' # Result in HTML format
#' read_data_package_report("knb-lter-knz.260.4", html = TRUE)
#'
read_data_package_report <- function(packageId, tier = "production", 
                                     html = FALSE, strip_ns = TRUE) {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/report/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
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
