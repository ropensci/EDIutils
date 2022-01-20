#' Get journal citation
#'
#' @param journalCitationId (numeric) Journal citation identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Journal citation
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
#' journalCitation
#' #> {xml_document}
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
get_journal_citation <- function(journalCitationId, env = "production") {
  url <- paste0(
    base_url(env), "/package/citation/eml/",
    journalCitationId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
