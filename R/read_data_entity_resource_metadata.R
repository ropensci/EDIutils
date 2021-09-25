#' Read data entity resource metadata
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param entityId (character) Data entity identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (xml_document) The resource metadata of \code{entityId} in \code{packageId}.
#' 
#' @export
#' 
#' @examples 
#' # Get resource metadata for the first data entity in "knb-lter-cce.310.1"
#' packageId <- "knb-lter-cce.310.1"
#' entityIds <- list_data_entities(packageId)
#' read_data_entity_resource_metadata(packageId, entityIds[1])
#'
read_data_entity_resource_metadata <- function(packageId, entityId, 
                                               tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/data/rmd/eml/",
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                entityId)
  resp <- httr::GET(url, set_user_agent())
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
