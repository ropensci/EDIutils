#' Read data package
#'
#' @param packageId (character) Data package identifier
#' @param ore (logical) Return an OAI-ORE compliant resource map in RDF-XML format
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (character or xml_document) A resource map with reference URLs to each of the metadata, data, and quality report resources that comprise the \code{packageId}.
#' 
#' @export
#' 
#' @examples 
#' # Get resource map
#' read_data_package("knb-lter-cwt.5026.13")
#' 
#' # Get resource map in ORE format
#' read_data_package("knb-lter-cwt.5026.13", ore = TRUE)
#'
read_data_package <- function(packageId, ore = FALSE, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/package/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
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
