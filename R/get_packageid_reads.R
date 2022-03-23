#' Get package ID reads
#'
#' @param packageId (character) Data package identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Summary of all the successful reads 
#' (total reads and non-robot reads) of \code{packageId}
#' 
#' @family Audit Manager Services
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get packageId reads
#' resourceReads <- get_packageid_reads("knb-lter-sgs.817.17")
#' }
get_packageid_reads <- function(packageId, 
                                as = "data.frame", 
                                env = "production") {
  url <- paste0(
    base_url(env), "/audit/reads/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
