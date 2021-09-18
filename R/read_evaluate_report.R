#' Read evaluate report
#'
#' @param transaction (character) Transaction identifier returned for each data package evaluate, upload, and delete operation
#' @param html (logical) Return result in HTML format?
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) The evaluate quality report document
#' 
#' @export
#' 
#' @examples 
#'
read_evaluate_report <- function(transaction, html = FALSE, 
                                 tier = "production") {
  
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
  return(parsed)
}