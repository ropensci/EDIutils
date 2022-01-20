#' List data descendants
#'
#' @description Data descendants are data packages that are known to be
#' derived, in whole or in part, from the specified source data package.
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Descendants of \code{packageId}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List descendants
#' dataDescendants <- list_data_descendants("knb-lter-bnz.501.17")
#' dataDescendants
#' #> {xml_document}
#' #> <dataDescendants>
#' #> [1] <dataDescendant>\n  <packageId>edi.275.1</packageId>\n  <title>&a ...
#' #> [2] <dataDescendant>\n  <packageId>edi.275.2</packageId>\n  <title>&a ...
#' #> [3] <dataDescendant>\n  <packageId>edi.275.3</packageId>\n  <title>&a ...
#' #> [4] <dataDescendant>\n  <packageId>edi.275.4</packageId>\n  <title>&a ...
#' #> [5] <dataDescendant>\n  <packageId>edi.275.5</packageId>\n  <title>&a ...
#' #> [6] <dataDescendant>\n  <packageId>edi.275.6</packageId>\n  <title>Ei ...
#' 
#' # Show first
#' xml2::xml_find_first(dataDescendants, "dataDescendant")
#' #> {xml_node}
#' #> <dataDescendant>
#' #> [1] <packageId>edi.275.1</packageId>
#' #> [2] <title>&amp;#xa;      Eight Mile Lake Research Watershed&amp;#x2c ...
#' #> [3] <url>https://pasta.lternet.edu/package/metadata/eml/edi/275/1</url>
#' }
list_data_descendants <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/descendants/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
