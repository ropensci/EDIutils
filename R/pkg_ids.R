#' Get data package IDs of a scope
#'
#' @description
#'     Get data package IDs for a specific scope.
#'
#' @usage pkg_ids(scope, environment = 'production')
#'
#' @param scope
#'     (character) Scope (e.g. 'edi', 'knb-lter-bnz').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (data frame) Data frame with columns:
#'     \itemize{
#'         \item{ids: Data package identifiers}
#'     }
#'
#' @export
#'

pkg_ids <- function(scope, environment = 'production'){
  
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
  
  output <- read.csv(
    text = c(
      'identifier',
      r
    ),
    as.is = T
  )
  
  output
  
}