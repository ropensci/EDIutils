#' Get doc ID reads
#'
#' @param scope (character) Scope of data package
#' @param identifier (numeric) Identifier of data package
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Summary of all the successful reads (total reads and non-robot reads) for all the resources of a given \code{scope} and \code{identifier}.
#' 
#' @export
#' 
#' @examples 
#' get_docid_reads("knb-lter-sgs", "817")
#'
get_docid_reads <- function(scope, identifier, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/audit/reads/", scope, "/", identifier)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
