#' List principal owner citations
#'
#' @param principalOwner (character) Principal owner in the format returned by
#' \code{create_dn()}
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Journal citations metadata for all entries owned by
#' the specified principal owner
#' 
#' @family Journal Citations
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List citations
#' dn <- create_dn(userId = "FCE", ou = "EDI")
#' journalCitations <- list_principal_owner_citations(principalOwner = dn)
#' journalCitations
#' #> {xml_document}
#' #> <journalCitations>
#' #>  [1] <journalCitation>\n  <journalCitationId>80</journalCitationId>\n ...
#' #>  [2] <journalCitation>\n  <journalCitationId>81</journalCitationId>\n ...
#' #>  [3] <journalCitation>\n  <journalCitationId>205</journalCitationId>\ ...
#' #>  [4] <journalCitation>\n  <journalCitationId>207</journalCitationId>\ ...
#' #>  [5] <journalCitation>\n  <journalCitationId>220</journalCitationId>\ ...
#' #>  [6] <journalCitation>\n  <journalCitationId>221</journalCitationId>\ ...
#' #>  [7] <journalCitation>\n  <journalCitationId>222</journalCitationId>\ ...
#' #>  [8] <journalCitation>\n  <journalCitationId>422</journalCitationId>\ ...
#' #>  [9] <journalCitation>\n  <journalCitationId>423</journalCitationId>\ ...
#' #> [10] <journalCitation>\n  <journalCitationId>424</journalCitationId>\ ...
#' }
list_principal_owner_citations <- function(principalOwner, env = "production") {
  url <- paste0(
    base_url(env), "/package/citations/eml/",
    principalOwner
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
