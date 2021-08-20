#' Read data entity sizes
#'
#' @description Read Data Entity Sizes operation, specifying the scope, identifier, and revision of the data package whose data entity sizes are to be read in the URI, returning a newline-separated list of entity identifiers and size values (in bytes). Each line in the list contains an entity identifier and its corresponding size value, separated by a comma. Only data entities that the user is authorized to read are included in the list.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data entity sizes (in bytes)
#' @details GET : https://pasta.lternet.edu/package/data/size/eml/{scope}/{identifier}/{revision}
#' @export
#' @examples
#'
read_data_entity_sizes <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving data entity sizes of', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/data/size/eml/',
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
