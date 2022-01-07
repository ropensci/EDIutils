#' List principal owner citations
#'
#' @param principalOwner (character) Principal owner in the format returned by
#' \code{construct_dn()}
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Journal citations metadata for all entries owned by
#' the specified principal owner
#'
#' @export
#'
#' @examples
#' # List citations
#' dn <- create_dn(userId = "FCE", ou = "EDI")
#' journalCitations <- list_principal_owner_citations(principalOwner = dn)
#' journalCitations
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
