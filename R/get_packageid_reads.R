#' Get package ID reads
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Summary of all the successful reads (total reads and
#' non-robot reads) of \code{packageId}
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
#' resourceReads
#' #> {xml_document}
#' #> <resourceReads>
#' #> [1] <resource>\n  <resourceId>https://pasta.lternet.edu/package/metada ...
#' #> [2] <resource>\n  <resourceId>https://pasta.lternet.edu/package/eml/kn ...
#' #> [3] <resource>\n  <resourceId>https://pasta.lternet.edu/package/report ...
#' #> [4] <resource>\n  <resourceId>https://pasta.lternet.edu/package/data/e ...
#' 
#' # Show first
#' resource <- xml2::xml_find_first(resourceReads, "resource")
#' resource
#' #> {xml_node}
#' #> <resource>
#' #> [1] <resourceId>https://pasta.lternet.edu/package/metadata/eml/knb-lte ...
#' #> [2] <resourceType>metadata</resourceType>
#' #> [3] <scope>knb-lter-sgs</scope>
#' #> [4] <identifier>817</identifier>
#' #> [5] <revision>17</revision>
#' #> [6] <totalReads>535</totalReads>
#' #> [7] <nonRobotReads>518</nonRobotReads>
#' }
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
