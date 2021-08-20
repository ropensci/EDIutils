#' Read data package error
#'
#' @description Read Data Package Error operation, specifying the scope, identifier, revision, and transaction identifier of the data package error to be read in the URI, returning the error message as plain text.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Reference URLs.
#' @details GET : https://pasta.lternet.edu/package/error/eml/{transaction}
#' @export
#' @examples 
#'
read_data_package_error <- function(package.id, environment = 'production'){
  # TODO implement
  message(paste('Retrieving resource map for', package.id))
  
  validate_arguments(x = as.list(environment()))

  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
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
