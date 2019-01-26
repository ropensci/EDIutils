#' Read data package report checksum
#'
#' @description
#'     Read Data Package Report Checksum operation, specifying the scope, 
#'     identifier, and revision of the data package report object whose 
#'     checksum is to be read in the URI, returning a 40 character SHA-1 
#'     checksum value.
#'
#' @usage read_data_package_report_checksum(package.id, environment = 
#'     'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data package report checksum
#'
#' @export
#'

read_data_package_report_checksum <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving data package report checksum for', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/report/checksum/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  output <- httr::content(
    r,
    as = 'text',
    encoding = 'UTF-8'
  )
  
  output
  
}