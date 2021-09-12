#' Get package ID reads
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) Summary of all the successful reads (total reads and non-robot reads) of \code{packageId}
#' 
#' @export
#' 
#' @examples 
#' get_packageid_reads("knb-lter-sgs.817.17")
#'
get_packageid_reads <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/audit/reads/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
