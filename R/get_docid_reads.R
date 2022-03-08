#' Get doc ID reads
#'
#' @param scope (character) Scope of data package
#' @param identifier (numeric) Identifier of data package
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Summary of all the successful reads 
#' (total reads and non-robot reads) for all the resources of a given 
#' \code{scope} and \code{identifier}.
#' 
#' @family Audit Manager Services
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get all reads
#' resourceReads <- get_docid_reads(scope = "knb-lter-sgs", identifier = 817)
#' }
get_docid_reads <- function(scope, 
                            identifier, 
                            as = "data.frame", 
                            env = "production") {
  url <- paste0(base_url(env), "/audit/reads/", scope, "/", identifier)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
