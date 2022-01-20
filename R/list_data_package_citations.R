#' List data package citations
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#' @param list_all (logical) Return all citations within a data package series?
#'
#' @return (xml_document) A list of journal citations
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
#' journalCitations
#' #> {xml_document}
#' #> <journalCitations>
#' #> [1] <journalCitation>\n  <journalCitationId>381</journalCitationId>\n  ...
#' 
#' # Show first
#' xml2::xml_find_first(journalCitations, "journalCitation")
#' #> {xml_node}
#' #> <journalCitation>
#' #> [1] <journalCitationId>381</journalCitationId>
#' #> [2] <packageId>edi.845.1</packageId>
#' #> [3] <principalOwner>uid=csmith,o=EDI,dc=edirepository,dc=org</principa ...
#' #> [4] <dateCreated>2021-05-27T13:23:14.981</dateCreated>
#' #> [5] <articleDoi>https://doi.org/10.1016/j.scitotenv.2021.148033</artic ...
#' #> [6] <articleTitle>Bioturbation frequency alters methane emissions from ...
#' #> [7] <articleUrl>https://doi.org/10.1016/j.scitotenv.2021.148033</artic ...
#' #> [8] <journalTitle>Science of the Total Environment</journalTitle>
#' #> [9] <relationType>IsCitedBy</relationType>
#' }
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
