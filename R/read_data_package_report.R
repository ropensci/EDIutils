#' Read data package report
#'
#' @param packageId (character) Data package identifier
#' @param html (logical) Return result in HTML format?
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Data package report
#' 
#' @export
#' 
#' @examples 
#' # Read report
#' qualityReport <- read_data_package_report(packageId = "knb-lter-knz.260.4")
#' qualityReport
#'
read_data_package_report <- function(packageId, html = FALSE, 
                                     env = "production") {
  url <- paste0(base_url(env), "/package/report/eml/",
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
