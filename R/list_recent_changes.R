#' List recent changes
#'
#' @description List Recent Changes operation, listing all data package insert, update, and delete operations, optionally specifying the date and time to and/or from which the changes should be listed. An optional scope value can be specified to filter results for a particular data package scope (e.g. scope=edi). If “fromDate” and “toDate” are omitted, lists the complete set of changes recorded in PASTA’a resource registry. If a “scope” value is omitted, results are returned for all data package scopes that exist in the resource registry. Multiple instances of the scope parameter are not supported (only the last scope value specified will be used). The list of changes is returned in XML format. Inserts and updates are recorded in “dataPackageUpload” elements, while deletes are recorded in “dataPackageDelete” elements. (See example below)
#'
#' @param from.date
#'     (character) Start date (e.g. '2019-01-01T12:00:00')
#' @param to.date
#'     (character) End date (e.g. '2019-01-25T12:00:00')
#' @param scope
#'     (character) Scope (e.g. 'edi')
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     ('xml_document' 'xml_node') dataPackageChanges 
#'     metadata.
#' @details GET : https://pasta.lternet.edu/package/changes/eml
#' @export
#' @examples 
#' # Using curl to list data packages that PASTA is working on uploading:
#'
list_recent_changes <- function(from.date = NULL, to.date = NULL, scope = NULL,
                                environment = 'production'){
  
  message('Listing recent data package changes')
  
  validate_arguments(x = as.list(environment()))
  
  if ((!is.null(from.date)) & (!is.null(to.date)) & (!is.null(scope))){
    
    r <- httr::GET(
      url = paste0(
        url_env(environment),
        '.lternet.edu/package/changes/eml',
        '?fromDate=',
        from.date,
        '&toDate=',
        to.date,
        '&scope=',
        scope
      )
    )

  } else if ((!is.null(from.date)) & (!is.null(to.date)) & (is.null(scope))){
    
    r <- httr::GET(
      url = paste0(
        url_env(environment),
        '.lternet.edu/package/changes/eml',
        '?fromDate=',
        from.date,
        '&toDate=',
        to.date
      )
    )
    
  }

  output <- httr::content(
    r,
    as = 'parsed',
    encoding = 'UTF-8'
  )
  
  output
  
}
