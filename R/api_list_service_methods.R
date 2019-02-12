#' List service methods
#'
#' @description
#'     List Service Methods operation, returning a simple list of web service 
#'     methods supported by the Data Package Manager web service.
#'
#' @usage api_list_service_methods(environment = 'production')
#'
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) All scope values extant in the data package registry.
#'
#' @export
#'

api_list_service_methods <- function(environment = 'production'){
  
  message(paste('Listing service methods supported by the Data Package Manager web services'))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/service-methods'
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