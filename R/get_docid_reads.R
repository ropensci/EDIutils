#' Get doc ID reads
#'
#' @param scope (character) Scope of data package (i.e. the first component of a \code{packageId})
#' @param identifier (numeric) Identifier of data package (i.e. the second component of a \code{packageId})
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) Summary of all the successful reads (total reads and non-robot reads) for all the resources of a given \code{scope} and \code{identifier}.
#' 
#' @export
#' 
#' @examples 
#' get_docid_reads("knb-lter-sgs", "817")
#'
get_docid_reads <- function(scope, identifier, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/audit/reads/", scope, "/", identifier)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
