#' List reservation identifiers
#'
#' @description List Reservation Identifiers operation, lists the set of numeric identifiers for the specified scope that end users have actively reserved for future upload to PASTA. The numeric identifiers are listed one per line.
#'
#' @param type
#'     (character) Upload type. Can be: "insert" or "update".
#' @param limit
#'     (integer) Maximum limit.
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('xml_document' 'xml_node') dataPackageUploads 
#'     metadata.
#' @details GET : https://pasta.lternet.edu/package/reservations/eml/{scope}
#' @export
#' @examples 
#' # Using curl to list reservation identifiers for a specified scope:
#'
list_reservation_identifiers <- function(type, limit = 5, environment = 'production'){
  
  message(paste('Retrieving recent uploads of type', type))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/uploads/eml',
      '?type=',
      type,
      '&limit=',
      limit
    )
  )
  
  output <- httr::content(
    r,
    as = 'parsed',
    encoding = 'UTF-8'
  )
  
  output
  
}
