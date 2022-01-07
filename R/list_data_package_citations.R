#' List data package citations
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#' @param list_all (logical) Return all citations within a data package series?
#'
#' @return (xml_document) A list of journal citations
#'
#' @export
#'
#' @examples
#' # List citations
#' journalCitations <- list_data_package_citations("edi.845.1")
#' journalCitations
#'
#' # Show first
#' xml2::xml_find_first(journalCitations, "journalCitation")
list_data_package_citations <- function(packageId,
                                        env = "production",
                                        list_all = FALSE) {
  url <- paste0(
    base_url(env), "/package/citations/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  if (list_all) {
    url <- paste0(url, "?all")
  }
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
