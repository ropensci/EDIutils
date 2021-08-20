#' Read data package from DOI
#'
#' @description Read Data Package From DOI operation, specifying the DOI of the data package to be read in the URI, returning a resource map with reference URLs to each of the metadata, data, and quality report resources that comprise the data package. The DOI is specified in the “shoulder”, “pasta”, and “md5” path segments of the URI (see example below). When the “?ore” query parameter is appended to the request URL, an OAI-ORE compliant resource map in RDF-XML format is returned.
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
#' @details GET : https://pasta.lternet.edu/package/doi/{shoulder}/{pasta}/{md5}
#' @export
#' @examples 
#' # Using curl to read a data package resource map by specifying the DOI as three path segments in the URL:
#'
read_data_package_from_doi <- function(package.id, environment = 'production'){
  
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
