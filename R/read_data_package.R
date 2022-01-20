#' Read data package
#'
#' @param packageId (character) Data package identifier
#' @param ore (logical) Return an OAI-ORE compliant resource map in RDF-XML
#' format
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character or xml_document) A resource map with reference URLs to
#' each of the metadata, data, and quality report resources that comprise the
#' \code{packageId}.
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get resource map
#' resourceMap <- read_data_package(packageId = "knb-lter-cwt.5026.13")
#' resourceMap
#' #> [1] "https://pasta.lternet.edu/package/data/eml/knb-lter-cwt/5026/13/ ...
#' #> [2] "https://pasta.lternet.edu/package/data/eml/knb-lter-cwt/5026/13/ ...
#' #> [3] "https://pasta.lternet.edu/package/metadata/eml/knb-lter-cwt/5026 ...
#' #> [4] "https://pasta.lternet.edu/package/report/eml/knb-lter-cwt/5026/1 ...
#' #> [5] "https://pasta.lternet.edu/package/eml/knb-lter-cwt/5026/13" 
#' 
#' # Get resource map in ORE format
#' resourceMap <- read_data_package(
#'  packageId = "knb-lter-cwt.5026.13",
#'  ore = TRUE
#' )
#' resourceMap
#' #> {xml_document}
#' #> <RDF xmlns:cito="http://purl.org/spar/cito/" xmlns:dc="http://purl.or ...
#' #> [1] <rdf:Description rdf:about="https://pasta.lternet.edu/package/eml ...
#' #> [2] <rdf:Description rdf:about="https://pasta.lternet.edu/package/eml ...
#' #> [3] <rdf:Description rdf:about="https://pasta.lternet.edu/package/eml ...
#' #> [4] <rdf:Description rdf:about="https://pasta.lternet.edu/package/eml ...
#' #> [5] <rdf:Description rdf:about="https://pasta.lternet.edu/package/eml ...
#' #> [6] <rdf:Description rdf:about="https://pasta.lternet.edu/package/eml ...
#' #> [7] <rdf:Description rdf:about="http://environmentaldatainitiative.or ...
#' #> [8] <rdf:Description rdf:about="http://www.openarchives.org/ore/terms ...
#' #> [9] <rdf:Description rdf:about="http://www.openarchives.org/ore/terms ...
#' }
read_data_package <- function(packageId, ore = FALSE, env = "production") {
  url <- paste0(
    base_url(env), "/package/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  if (ore) {
    url <- paste0(url, "?ore")
  }
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  if (ore) {
    return(xml2::read_xml(res))
  } else {
    return(text2char(res))
  }
}
