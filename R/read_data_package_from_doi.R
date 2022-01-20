#' Read data package from Digital Object Identifier
#'
#' @param doi (character) Digital Object Identifier of data package in the
#' format "shoulder/pasta/md5"
#' @param ore (logical) Return an OAI-ORE compliant resource map in RDF-XML
#' format
#'
#' @return (character or xml_document) A resource map with reference URLs to
#' each of the metadata, data, and quality report resources that comprise the
#' data package.
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get resource map
#' resourceMap <- read_data_package_from_doi(
#'  doi = "doi:10.6073/pasta/b202c11db7c64943f6b4ed9f8c17fb25"
#' )
#' resourceMap
#' #> [1] "https://pasta.lternet.edu/package/data/eml/knb-lter-fce/1233/2/5 ...
#' #> [2] "https://pasta.lternet.edu/package/metadata/eml/knb-lter-fce/1233/2"
#' #> [3] "https://pasta.lternet.edu/package/report/eml/knb-lter-fce/1233/2"
#' #> [4] "https://pasta.lternet.edu/package/eml/knb-lter-fce/1233/2"
#' 
#' # Get resource map in ORE format
#' resourceMap <- read_data_package_from_doi(
#'  doi = "doi:10.6073/pasta/b202c11db7c64943f6b4ed9f8c17fb25",
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
#' #> [6] <rdf:Description rdf:about="http://environmentaldatainitiative.or ...
#' #> [7] <rdf:Description rdf:about="http://www.openarchives.org/ore/terms ...
#' #> [8] <rdf:Description rdf:about="http://www.openarchives.org/ore/terms ...
#' }
read_data_package_from_doi <- function(doi, ore = FALSE) {
  url <- paste0(base_url("production"), "/package/doi/", doi)
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
