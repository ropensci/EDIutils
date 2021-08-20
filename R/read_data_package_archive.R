#' Read data package archive
#'
#' @description Read Data Package Archive operation, specifying the transaction identifier of the data package archive to be read in the URI, returning the data package archive as a binary object in the ZIP file format.
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
#' @details GET : https://pasta.lternet.edu/package/archive/eml/{scope}/{identifier}/{revision}/{transaction}
#' @export
#' @examples 
#' # Using curl to read a data package archive and redirect the output to a file:
#'
read_data_package_archive <- function(package.id, environment = 'production'){
  
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
