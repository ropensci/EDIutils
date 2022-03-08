#' List principal owner citations
#'
#' @param principalOwner (character) Principal owner in the format returned by
#' \code{create_dn()}
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Journal citations metadata for all 
#' entries owned by the specified principal owner
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
#' }
list_principal_owner_citations <- function(principalOwner, 
                                           as = "data.frame", 
                                           env = "production") {
  url <- paste0(
    base_url(env), "/package/citations/eml/",
    principalOwner
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
