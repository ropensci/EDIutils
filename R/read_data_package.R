#' Read data package
#'
#' @description Read Data Package operation, specifying the scope, identifier, and revision of the data package to be read in the URI, returning a resource map with reference URLs to each of the metadata, data, and quality report resources that comprise the data package. Revision may be specified as “newest” or “oldest” to retrieve the newest or oldest revision, respectively. When the “?ore” query parameter is appended to the request URL, an OAI-ORE compliant resource map in RDF-XML format is returned.
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
#' @details GET : https://pasta.lternet.edu/package/eml/{scope}/{identifier}/{revision}
#' @export
#' @examples 
#' # Using curl to read a data package resource map:
#' 
#' # Using curl to read a data package resource map, using the “?ore” query parameter to specify that the resource map should be returned as an OAI-ORE compliant RDF-XML document:
#'
read_data_package <- function(package.id, environment = 'production'){
  
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
