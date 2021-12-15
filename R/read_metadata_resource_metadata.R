#' Read metadata resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return (xml_document) Resource metadata for the data package metadata resource
#' 
#' @export
#' 
#' @examples 
#' read_metadata_resource_metadata("knb-lter-pal.309.1")
#'
read_metadata_resource_metadata <- function(packageId, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/package/metadata/rmd/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
