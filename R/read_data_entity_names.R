#' Read data entity names
#'
#' @description
#'     Read Data Entity Names operation, specifying the scope, identifier, 
#'     and revision of the data package whose data entity names are to be 
#'     read in the URI. Only data entities that the user is authorized to 
#'     read are included in the list.
#'
#' @usage read_data_entity_names(package.id, identifier, 
#'     environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data entity names
#'
#' @export
#'

read_data_entity_names <- function(package.id, identifier, environment = 'production'){
  
  message(paste('Retrieving data entity names of', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/name/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
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