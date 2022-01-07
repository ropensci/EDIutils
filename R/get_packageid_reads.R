#' Get package ID reads
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Summary of all the successful reads (total reads and
#' non-robot reads) of \code{packageId}
#'
#' @export
#'
#' @examples
#' # Get packageId reads
#' resourceReads <- get_packageid_reads("knb-lter-sgs.817.17")
#' resourceReads
#'
#' # Show first
#' resource <- xml2::xml_find_first(resourceReads, "resource")
#' resource
get_packageid_reads <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/audit/reads/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
