#' List principal owner citations
#'
#' @param principalOwner (character) The EDI ID of the principal owner. 
#' EDI IDs can be obtained from the EDI Identity and Access 
#' Manager (\url{https://auth.edirepository.org/auth/ui/signin}).
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
#' edi_id <- "EDI-543afa80c859825d35d37d9111c24a4a65a0ff9e"
#' journalCitations <- list_principal_owner_citations(principalOwner = edi_id)
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
