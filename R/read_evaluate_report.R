#' Read evaluate report
#'
#' @param transaction (character) Transaction identifier
#' @param html (logical) Return result in HTML format?
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) The evaluate quality report document. Get high-level results with \code{summarize_quality_report()}
#' 
#' @note User authentication is required (see \code{login()})
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
#' # Result in HTML format. Write to file for human review.
#' qualityReport <- read_evaluate_report(transaction, html = TRUE)
#' xml2::write_html(qualityReport, "/Users/me/Documents/qualityReport.html")
#'
read_evaluate_report <- function(transaction, 
                                 html = FALSE, 
                                 tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/evaluate/report/eml/",
                transaction)
  cookie <- bake_cookie()
  if (html) {
    resp <- httr::GET(url, 
                      set_user_agent(), 
                      cookie, 
                      httr::accept("text/html"), 
                      handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_html(res))
  } else {
    resp <- httr::GET(url, 
                      set_user_agent(), 
                      cookie, 
                      handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_xml(res))
  }
  # TODO return summary as message
  # r_content <- httr::content(r, type = 'text', encoding = 'UTF-8')
  # check_status <- unlist(
  #   stringr::str_extract_all(r_content, '[:alpha:]+(?=</status>)'))
  # check_datetime <- unlist(
  #   stringr::str_extract_all(
  #     r_content, '(?<=<creationDate>)[:graph:]+(?=</creationDate>)'))
  # n_valid <- as.character(sum(check_status == 'valid'))
  # n_warn <- as.character(sum(check_status == 'warn'))
  # n_error <- as.character(sum(check_status == 'error'))
  # n_info <- as.character(sum(check_status == 'info'))
  # message(paste0(
  #   'EVALUATE RESULTS\n',
  #   'Package Id: ', package.id, '\n',
  #   'Was Evaluated: Yes\n',
  #   'Report: ', paste0(url_env(environment),
  #                      '.lternet.edu/package/evaluate/report/eml/',
  #                      transaction_id), '\n',
  #   'Creation Date:', check_datetime, '\n',
  #   'Total Quality Checks: ', length(check_status), '\n',
  #   'Valid: ', n_valid, '\n',
  #   'Info: ', n_info, '\n',
  #   'Warn: ', n_warn, '\n',
  #   'Error: ', n_error, '\n'))
}