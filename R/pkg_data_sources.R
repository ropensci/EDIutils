#' Get data sources of a data package
#'
#' @description
#'     Get data sources of a data package. Data sources can be either internal 
#'     or external to PASTA+.
#'
#' @usage pkg_data_sources(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('XMLInternalDocument' 'XMLAbstractDocument') For each data source, its 
#'     package identifier, title, and URL values are included (if applicable) 
#'     as documented in the metadata for the specified data package. Internal 
#'     data sources include a “packageId” value and a URL to the source 
#'     metadata. For data sources external to PASTA, the “packageId” element 
#'     will be empty and a URL value may or not be documented.
#'
#' @export
#'

pkg_data_sources <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving data sources of data package', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/sources/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  output <- XML::xmlParse(
    httr::content(
      r,
      as = 'parsed',
      encoding = 'UTF-8'
    )
  )
  
  output
  
}