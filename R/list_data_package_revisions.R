#' List data package revisions
#'
#' @param scope (character) Scope of data package
#' @param identifier (numeric) Identifier of data package
#' @param filter (character) Filter results by "newest" or "oldest"
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
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
                                        env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/package/eml/",
                paste(c(scope, as.character(identifier)), collapse = "/"))
  if (!is.null(filter)) {
    url <- paste0(url, "?filter=", filter)
  }
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
