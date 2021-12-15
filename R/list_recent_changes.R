#' List recent changes
#'
#' @description List all data package insert, update, and delete operations, optionally specifying the date and time to and/or from which the changes should be listed. An optional scope value can be specified to filter results for a particular data package scope.
#'
#' @param fromDate (character) Start date in the format "YYYY-MM-DDThh:mm:ss"
#' @param toDate (character) End date in the format "YYYY-MM-DDThh:mm:ss"
#' @param scope (character) Scope of data package
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Recent changes and their corresponding packageId, scope, identifier, revision, principal, doi, serviceMethod, and date.
#' 
#' @export
#' 
#' @examples 
#' # Changes occurring in January 2021 within the scope "knb-lter-hbr"
#' list_recent_changes(
#'   fromDate = "2021-01-01T00:00:00", 
#'   toDate = "2021-02-01T00:00:00", 
#'   scope = "knb-lter-hbr")
#'   
#' # Changes occurring in the first 3 days of 2021 for all scopes
#' list_recent_changes(
#'   fromDate = "2021-01-01T00:00:00", 
#'   toDate = "2021-01-03T00:00:00")
#'
list_recent_changes <- function(fromDate = NULL, toDate = NULL, scope = NULL,
                                env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/package/changes/eml")
  if (any(c(!is.null(fromDate), !is.null(toDate), !is.null(scope)))) {
    url <- paste0(url, "?")
  }
  if (!is.null(fromDate) & !is.null(toDate)) {
    url <- paste0(url, "&fromDate=", fromDate, "&toDate=", toDate)
  }
  if (!is.null(scope)) {
    url <- paste0(url, "&scope=", scope)
  }
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
