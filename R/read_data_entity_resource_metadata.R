#' Read data entity resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) The resource metadata of \code{entityId} in
#' \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' # List entities
#' entityIds <- list_data_entities(packageId = "knb-lter-cce.310.1")
#' head(entityIds)
#'
#' # Read resource metadata for first entity
#' resourceMetadata <- read_data_entity_resource_metadata(
#'   packageId = "knb-lter-cce.310.1",
#'   entityId = entityIds[1]
#' )
#' resourceMetadata
read_data_entity_resource_metadata <- function(packageId, entityId,
                                               env = "production") {
  url <- paste0(
    base_url(env), "/package/data/rmd/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
