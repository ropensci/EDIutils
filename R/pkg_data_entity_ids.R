#' Get data entity IDs
#'
#' @description
#'     Get identifiers of data entities.
#'
#' @usage pkg_data_entity_ids(package.id, environment = 'production')
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (data frame) A data frame with columns:
#'     \itemize{
#'         \item{identifier: Data entity identifier}
#'     }
#'
#' @export
#'

pkg_data_entity_ids <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving data entity IDs for data package', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/data/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  r <- httr::content(
    r,
    as = 'text',
    encoding = 'UTF-8'
  )
  
  output <- read.csv(
    text = c(
      'identifier',
      r
    ),
    as.is = T
  )
  
  output
  
}