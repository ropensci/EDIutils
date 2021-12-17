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
#' # Get citation
#' journalCitation <- get_journal_citation(381)
#' journalCitation
#'
get_journal_citation <- function(journalCitationId, env = "production") {
  url <- paste0(base_url(env), "/package/citation/eml/", 
                journalCitationId)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
