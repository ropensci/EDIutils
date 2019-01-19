#' Get data entity names
#'
#' @description
#'     Get names of data entities and corresponding IDs.
#'
#' @usage pkg_data_entity_names(package.id, environment = 'production')
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
#'         \item{}
#'         \item{}
#'     }
#'
#' @export
#'

pkg_data_entity_names <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving data entity names for data package', package.id))
  
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
  
  output <- read.csv(
    text = c(
      c('identifier,name\n'),
      r
    ),
    as.is = T
  )
  
  output
  
}