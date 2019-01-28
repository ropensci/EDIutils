#' List deleted data packages
#'
#' @description
#'     List Deleted Data Packages operation, returning all document identifiers 
#'     (excluding revision values) that have been deleted from the data package 
#'     registry.
#'
#' @usage api_list_data_package_scopes(environment = 'production')
#'
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Deleted data packages
#'
#' @export
#'

api_list_deleted_data_packages <- function(environment = 'production'){
  
  message(paste('Listing deleted data packages in the', environment, 'environment'))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/eml/deleted'
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