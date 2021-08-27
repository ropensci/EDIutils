#' Read data package from Digital Object Identifier
#'
#' @param doi (character) Data package DOI of the form "shoulder/pasta/md5"
#' @param ore (logical) Return an OAI-ORE compliant resource map in RDF-XML format
#'
#' @return (character or xml_document) A resource map with reference URLs to each of the metadata, data, and quality report resources that comprise the data package.
#' 
#' @export
#' 
#' @examples
#' # Get resource map
#' read_data_package_from_doi(
#'   doi = "doi:10.6073/pasta/b202c11db7c64943f6b4ed9f8c17fb25")
#' 
#' # Get resource map in ORE format
#' read_data_package_from_doi(
#'   doi = "doi:10.6073/pasta/b202c11db7c64943f6b4ed9f8c17fb25", 
#'   ore = TRUE)
#'
read_data_package_from_doi <- function(doi, ore = FALSE) {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env("production"), ".lternet.edu/package/doi/", doi)
  if (isTRUE(ore)) {
    url <- paste0(url, "?ore")
  }
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  if (isTRUE(ore)) {
    parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
    return(parsed)
  } else {
    parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
    res <- text2char(parsed)
    return(res)
  }
}
