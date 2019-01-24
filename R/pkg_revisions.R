#' Get revisions of a data package
#'
#' @description
#'     Get data package revisions. The request may be filtered by the modifiers 
#'     “oldest” or “newest”.
#'
#' @usage pkg_revisions(scope, identifier, filter = NULL, 
#'     environment = 'production')
#'
#' @param scope
#'     (character) Data package scope (e.g. 'edi', 'knb-lter-bnz').
#' @param identifier
#'     (character) Data package identifier (e.g. '100', '275').
#' @param filter
#'     (character) Filter to data packages, can be 'oldest' or 'newest'.
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Vector of revisions, if more than one exists, otherwise a 
#'     single revision number.
#'
#' @export
#'

pkg_revisions <- function(scope, identifier, filter = NULL, environment = 'production'){
  
  message(paste('Retrieving data package revisions for', 
                paste(scope, '.', identifier)
                )
          )
  
  validate_arguments(x = as.list(environment()))
  
  if (is.null(filter)){
    
    r <- httr::GET(
      url = paste0(
        url_env(environment),
        '.lternet.edu/package/eml/',
        scope,
        '/',
        identifier
      )
    )
    
    r <- httr::content(
      r,
      as = 'text',
      encoding = 'UTF-8'
    )
    
    output <- read.csv(
      text = c(
        'revision',
        r
      ),
      as.is = T
    )
    
    output <- output$revision
    
  } else if (filter == 'newest'){
    
    r <- httr::GET(
      url = paste0(
        url_env(environment),
        '.lternet.edu/package/eml/',
        scope,
        '/',
        identifier,
        '?filter=newest'
      )
    )
    
    output <- httr::content(
        r,
        as = 'text',
        encoding = 'UTF-8'
    )

  } else if (filter == 'oldest'){
    
    r <- httr::GET(
      url = paste0(
        url_env(environment),
        '.lternet.edu/package/eml/',
        scope,
        '/',
        identifier,
        '?filter=oldest'
      )
    )
    
    output <- httr::content(
        r,
        as = 'text',
        encoding = 'UTF-8'
    )
    
  }
  
  output

}