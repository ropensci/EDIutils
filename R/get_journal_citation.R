#' Get journal citation
#'
#' @param journalCitationId (numeric) Journal citation identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Journal citation
#' 
#' @export
#' 
#' @examples 
#' # Get first journal citation of data package edi.845.1
#' journalCitationIds <- list_data_package_citations("edi.845.1")
#' journalCitationId <- xml2::xml_text(
#'   xml2::xml_find_first(citations, ".//journalCitationId"))
#' get_journal_citation(journalCitationId)
#'
get_journal_citation <- function(journalCitationId, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/package/citation/eml/", 
                journalCitationId)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
