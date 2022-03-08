#' Get journal citation
#'
#' @param journalCitationId (numeric) Journal citation identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Journal citation
#' 
#' @family Journal Citations
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get citation
#' journalCitation <- get_journal_citation(381)
#' }
get_journal_citation <- function(journalCitationId, 
                                 as = "data.frame",
                                 env = "production") {
  url <- paste0(
    base_url(env), "/package/citation/eml/",
    journalCitationId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
