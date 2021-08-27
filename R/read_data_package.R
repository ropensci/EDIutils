#' Read data package
#'
#' @param package.id (character) Package identifier composed of scope, identifier, and revision (e.g. "edi.101.1")
#' @param filter (character) Filter returned revisions. Can be "newest" or "oldest"
#' @param ore (logical) Return an OAI-ORE compliant resource map in RDF-XML format
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) A resource map with reference URLs to each of the metadata, data, and quality report resources that comprise the data package. 
#' 
#' @details GET : https://pasta.lternet.edu/package/eml/{scope}/{identifier}/{revision}
#' 
#' @export
#' 
#' @examples 
#' # Read a data package resource map
#' 
#' # Read a data package resource map in OAI-ORE compliant format
#'
read_data_package <- function(package.id, 
                              filter = NULL, 
                              ore = FALSE, 
                              environment = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  # FIXME The filter arg doesn't belong here. It is actually the revision value that can recieve the "newest" and "oldest" values. This is a reason to implement sir over package.id (i.e. sir exercises full PASTA+ functionality in the case of this API call)
  url <- paste0(url_env(environment), ".lternet.edu/package/eml/",
                paste(parse_packageId(package.id), collapse = "/"))
  if (!is.null(filter)) {
    url <- paste0(url, "?filter=", filter)
  }
  if (isTRUE(ore)) {
    url <- paste0(url, "?ore")
  }
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  if (output == "data.frame") {
    res <- xml2df(parsed)
    return(res)
  } else {
    res <- parsed
    return(res)
  }

  if (!is.null(filter)) {
    url <- paste0(url, "?filter=", filter)
  }
  
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
