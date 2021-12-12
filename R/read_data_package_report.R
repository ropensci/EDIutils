#' Read data package report
#'
#' @param packageId (character) Data package identifier
#' @param html (logical) Return result in HTML format?
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Data package report
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
read_data_package_report <- function(packageId, html = FALSE, 
                                     tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/report/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  if (html) {
    resp <- httr::GET(url, 
                      set_user_agent(), 
                      httr::accept("text/html"), 
                      handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_html(res))
  } else {
    resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_xml(res))
  }
}
