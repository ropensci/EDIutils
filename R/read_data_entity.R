#' Read data entity
#'
#' @param package.id (character) Package identifier composed of scope, identifier, and revision (e.g. "edi.101.1").
#' @param entityId (character) Identifier of data entity to read (e.g. 5c224a0e74547b14006272064dc869b1)
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (character) Data entity checksum
#' 
#' @details GET : https://pasta.lternet.edu/package/data/eml/{scope}/{identifier}/{revision}/{entityId}
#' 
#' @export
#' 
#' @examples 
#'
read_data_entity <- function(package.id, entityId, environment = "production") {
  validate_arguments(x = as.list(environment()))
  pkg <- parse_packageId(package.id)
  url <- paste0(url_env(environment), ".lternet.edu/package/data/eml/",
                paste(pkg, collapse = "/"), "/", entityId)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  raw <- httr::content(resp, as = "raw", encoding = "UTF-8")
  # TODO Implement readers for common data types, but also allow pass through of arguments to httr so user can handle edge cases. This func could be wrapped by read_tables() et al..
  return(raw)
}