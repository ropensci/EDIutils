#' Read data entity name
#'
#' @description
#'     Read Data Entity Name operation, specifying the scope, identifier, 
#'     revision, and entity identifier of the data entity whose name is 
#'     to be read in the URI.
#'
#' @usage read_data_entity_name(package.id, identifier, 
#'     environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param identifier
#'     (character) Data entity identifier (e.g. 
#'     5c224a0e74547b14006272064dc869b1)
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data entity name
#'
#' @export
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