#' Read data entity size
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param entityId (character) Data entity identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @return (numeric) Size, in bytes, of \code{entityId} in \code{packageId}
#' 
#' @export
#' 
#' @examples 
#' # Get size of first data entity in data package "knb-lter-cdr.711.1
#' packageId <- "knb-lter-cdr.711.1"
#' entityIds <- list_data_entities(packageId)
#' read_data_entity_size(packageId, entityIds[1])
#'
read_data_entity_size <- function(packageId, entityId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/data/size/eml/", 
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                entityId)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
