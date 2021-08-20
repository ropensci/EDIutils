#' Get event subscription
#'
#' @description Get Event Subscription returns the event subscription with the specified ID.
#'
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ("xml_document" "xml_node") EML metadata.
#'     
#' @details GET : https://pasta.lternet.edu/package/event/eml/{subscriptionId}
#' @export
#' @examples 
#'
get_event_subscription <- function(package.id, environment = 'production'){
  
  message(paste('Retrieving provenance metadata for ', package.id))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/provenance/eml/',
      stringr::str_replace_all(package.id, '\\.', '/')
    )
  )
  
  output <- httr::content(
    r,
    as = 'parsed',
    encoding = 'UTF-8'
  )
  
  output
  
}
