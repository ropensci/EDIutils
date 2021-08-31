#' List data package revisions
#'
#' @param scope (character) Scope of data package (i.e. the first component of a \code{packageId})
#' @param identifier (numeric) Identifier of data package (i.e. the second component of a \code{packageId})
#' @param filter (character) Filter results by "newest" or "oldest"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (numeric) Revisions of a data package within a specified \code{scope} and \code{identifier}
#' 
#' @export
#' 
#' @examples 
#' # All revisions
#' list_data_package_revisions("knb-lter-arc", 20131)
#' 
#' # Newest revision
#' list_data_package_revisions("knb-lter-arc", 20131, filter = "newest")
#' 
#' # Oldest revision
#' list_data_package_revisions("knb-lter-arc", 20131, filter = "oldest")
#' 
list_data_package_revisions <- function(scope, identifier, filter = NULL, 
                                        tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/eml/",
                paste(c(scope, as.character(identifier)), collapse = "/"))
  if (!is.null(filter)) {
    url <- paste0(url, "?filter=", filter)
  }
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- as.numeric(text2char(parsed))
  return(res)
}
