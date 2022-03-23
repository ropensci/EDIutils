#' List data package citations
#'
#' @param packageId (character) Data package identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param list_all (logical) Return all citations within a data package series?
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) A list of journal citations
#' 
#' @family Journal Citations
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List citations
#' journalCitations <- list_data_package_citations("edi.845.1")
#' }
list_data_package_citations <- function(packageId,
                                        as = "data.frame",
                                        list_all = FALSE,
                                        env = "production") {
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
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
