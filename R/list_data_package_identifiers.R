#' List data package identifiers
#'
#' @description List Data Package Identifiers operation, specifying the scope value to match in the URI.
#'
#' @param scope
#'     (character) Scope (e.g. 'edi', 'knb-lter-bnz').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data package identifiers
#'
#' @export
#' 
#' @examples 
#' # GET : https://pasta.lternet.edu/package/eml/{scope}
#'

list_data_package_identifiers <- function(scope, environment = 'production'){
  
  message(paste('Retrieving data package IDs for scope', scope))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/eml/',
      scope
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
