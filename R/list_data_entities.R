#' List data entities
#' 
#' @param scope (character) Data package scope
#' @param identifier (character) Data package identifier
#' @param revision (character) Data package revision
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: 'production', 'staging', or 'development'
#' 
#' @return (character) Data entity identifier(s) of the specified data package
#' 
#' @details GET : https://pasta.lternet.edu/package/data/eml/{scope}/{identifier}/{revision}
#' 
#' @export
#' 
#' @examples
#' list_data_entities(scope = "edi", identifier = "193", revision = "5")
#'
list_data_entities <- function(scope, identifier, revision, 
                               environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/data/eml/",
                paste(c(scope, identifier, revision), collapse = "/"))
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
