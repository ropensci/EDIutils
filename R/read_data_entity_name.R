#' Read data entity name
#'
#' @param package.id (character) Package identifier composed of scope, identifier, and revision (e.g. "edi.101.1")
#' @param entityId (character) Data entity identifier (e.g. "5c224a0e74547b14006272064dc869b1")
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development".
#'
#' @return (character) Data entity name
#' 
#' @details GET : https://pasta.lternet.edu/package/name/eml/{scope}/{identifier}/{revision}/{entityId}
#' 
#' @export
#' 
#' @examples 
#'
read_data_entity_name <- function(package.id, identifier, environment = 'production'){
  
  message(paste('Retrieving name of', package.id, identifier))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/name/eml/',
      stringr::str_replace_all(package.id, '\\.', '/'),
      '/',
      identifier
    )
  )
  
  r <- httr::content(
    r,
    as = 'text',
    encoding = 'UTF-8'
  )
  
  output <- as.character(
    read.csv(
      text = c(
        'identifier',
        r
      ),
      as.is = T
    )$identifier
  )
  
  output
  
}
