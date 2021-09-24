#' Read data entity
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param entityId (character) Data entity identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (raw) Raw bytes (i.e. application/octet-stream) to be parsed by a reader function appropriate for the data type
#' 
#' @export
#' 
#' @examples
#' # Get raw bytes of a .csv and use parser of choice
#' packageId <- "edi.993.1"
#' entityId <- list_data_entities(packageId)
#' raw <- read_data_entity(packageId, entityId)
#' data <- readr::read_csv(raw)
#'
read_data_entity <- function(packageId, entityId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/data/eml/", 
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                entityId)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  httr::stop_for_status(resp)
  raw <- httr::content(resp, as = "raw", encoding = "UTF-8")
  # TODO Implement reader options for dataTable, spatialRaster, spatialVector, etc., listing their dependencies under DESCRIPTION/suggests. Parse EML into reader arguments. Preserve raw option.
  return(raw)
}