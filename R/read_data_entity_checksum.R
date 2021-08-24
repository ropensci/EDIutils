#' Read data entity checksum
#'
#' @param package.id (character) Package identifier composed of scope, identifier, and revision (e.g. "edi.101.1").
#' @param entityId (character) Data entity identifier (e.g. 5c224a0e74547b14006272064dc869b1)
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#' 
#' @return (character) Data entity checksum value
#'     
#' @details GET : https://pasta.lternet.edu/package/data/checksum/eml/{scope}/{identifier}/{revision}/{entityId}
#' 
#' @export
#' 
#' @examples 
#' 
#' 
read_data_entity_checksum <- function(package.id, 
                                      entityId, 
                                      environment = "production") {
  validate_arguments(x = as.list(environment()))
  pkg <- parse_packageId(package.id)
  url <- paste0(url_env(environment), ".lternet.edu/package/data/checksum/eml/",
                paste(pkg, collapse = "/"), "/", entityId)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
