#' List working on
#'
#' @description
#'     List Working On operation, lists the set of data packages that PASTA is 
#'     currently working on inserting or updating. (Note that data packages 
#'     currently being evaluated by PASTA are not included in the list.)
#'
#' @usage list_working_on(environment = 'production')
#'
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('XMLInternalDocument' 'XMLAbstractDocument') workingOn metadata
#'
#' @export
#'

list_working_on <- function(environment = 'production'){
  
  message('Data packages PASTA+ is working on inserting or updating:')
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/workingon/eml/'
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