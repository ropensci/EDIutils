#' Read data entity checksum
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param entityId (character) Data entity identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @return (character) Checksum value of \code{entityId} in \code{packageId}
#' 
#' @export
#' 
#' @examples 
#' list_data_entities("knb-lter-ble.1.7")
#' 
read_data_entity_checksum <- function(packageId, entityId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  pkg <- parse_packageId(packageId)
  url <- paste0(url_env(tier), ".lternet.edu/package/data/checksum/eml/",
                paste(pkg, collapse = "/"), "/", entityId)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
