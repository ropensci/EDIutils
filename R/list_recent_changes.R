#' List recent changes
#'
#' @description List all data package insert, update, and delete operations, optionally specifying the date and time to and/or from which the changes should be listed. An optional scope value can be specified to filter results for a particular data package scope.
#'
#' @param fromDate (character) Start date (e.g. "2019-01-01T12:00:00")
#' @param toDate (character) End date (e.g. "2019-01-25T12:00:00")
#' @param scope (character) Data package scope
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (xml_document) packageId, scope, identifier, revision, principal, doi, serviceMethod, and date of data package changes.
#'     
#' @details 
#' GET : https://pasta.lternet.edu/package/changes/eml
#' 
#' If "fromDate" and "toDate" are omitted, lists the complete set of changes recorded in PASTA's  resource registry. If a "scope" value is omitted, results are returned for all data package scopes that exist in the resource registry. Multiple instances of the scope parameter are not supported. Inserts and updates are recorded in "dataPackageUpload" elements, while deletes are recorded in "dataPackageDelete" elements.
#' 
#' @export
#' 
#' @examples 
#' # Changes occurring in January 2021 for the scope "knb-lter-hbr"
#' list_recent_changes(
#'   fromDate = "2021-01-01T00:00:00", 
#'   toDate = "2021-02-01T00:00:00", 
#'   scope = "knb-lter-hbr")
#'   
#' # Changes occurring in January 2021 for all scopes
#' list_recent_changes(
#'   fromDate = "2021-01-01T00:00:00", 
#'   toDate = "2021-02-01T00:00:00")
#'
list_recent_changes <- function(fromDate = NULL, 
                                toDate = NULL, 
                                scope = NULL,
                                environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/changes/eml")
  if (any(c(!is.null(fromDate), !is.null(toDate), !is.null(scope)))) {
    url <- paste0(url, "?")
  }
  if (!is.null(fromDate) & !is.null(toDate)) {
    url <- paste0(url, "&fromDate=", fromDate, "&toDate=", toDate)
  }
  if (!is.null(scope)) {
    url <- paste0(url, "&scope=", scope)
  }
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
