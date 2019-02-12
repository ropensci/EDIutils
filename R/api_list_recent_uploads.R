#' List recent uploads
#'
#' @description
#'     List Recent Uploads operation, optionally specifying the upload type 
#'     (“insert” or “update”) and a maximum limit as query parameters in the 
#'     URL.
#'
#' @usage api_list_recent_uploads(type, limit = 5, environment = 'production')
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
#'
#' @export
#'

api_list_recent_uploads <- function(type, limit = 5, environment = 'production'){
  
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