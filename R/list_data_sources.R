#' List data sources
#'
#' @description Data sources are data packages, or other online digital
#' objects, that are known to be inputs to the specified derived data package.
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Data sources to \code{packageId}
#'
#' @details Data sources can be either internal or external to the EDI data
#' repository. Internal data sources include a packageId value and a URL to the
#' source metadata. For data sources external to PASTA, the packageId element
#' will be empty and a URL value may or not be documented.
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List sources
#' dataSources <- list_data_sources("edi.275.4")
#' dataSources
#' #> {xml_document}
#' #> <dataSources>
#' #> [1] <dataSource>\n  <packageId>knb-lter-bnz.501.17</packageId>\n  <ti ...
#' 
#' # Show first
#' xml2::xml_find_first(dataSources, "dataSource")
#' #> {xml_node}
#' #> <dataSource>
#' #> [1] <packageId>knb-lter-bnz.501.17</packageId>
#' #> [2] <title>Eight Mile Lake Research Watershed&amp;#x2c; Carbon in Per ...
#' #> [3] <url>https://pasta.lternet.edu/package/metadata/eml/knb-lter-bnz/ ...
#' }
list_data_sources <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/sources/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
