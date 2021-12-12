#' Read evaluate report
#'
#' @param transaction (character) Transaction identifier
#' @param format (character) Format of the returned report. Can be: "xml", "html", or "character".
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (xml_document/html_document/character) The evaluate quality report document
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @details If \code{format = "character"}, the report is parsed into a character string. Wrap in \code{message()} or write to file for human readability.
#' 
#' @export
#' 
#' @examples 
#' # Evaluate data package
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' transaction <- evaluate_data_package(path)
#' 
#' # Result in XML format
#' qualityReport <- read_evaluate_report(transaction)
#' 
#' # Result in HTML format
#' qualityReport <- read_evaluate_report(transaction, format = "html")
#' 
#' # Result as character string
#' qualityReport <- read_evaluate_report(transaction, format = "character")
#' message(qualityReport)
#' writeLines(qualityReport, "/Users/me/Documents/report.txt"))
#'
read_evaluate_report <- function(transaction, 
                                 format = "xml", 
                                 tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/evaluate/report/eml/",
                transaction)
  cookie <- bake_cookie()
  if (format == "html") {
    resp <- httr::GET(url, 
                      set_user_agent(), 
                      cookie, 
                      httr::accept("text/html"), 
                      handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_html(res))
  } else if (format %in% c("xml", "character")) {
    resp <- httr::GET(url, 
                      set_user_agent(), 
                      cookie, 
                      handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    if (format == "xml") {
      return(xml2::read_xml(res))
    } else if (format == "character") {
      char <- report2char(xml2::read_xml(res), tier = tier)
      return(char)
    }
  }
}