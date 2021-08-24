#' List data package revisions
#'
#' @param scope (character) Data package scope (e.g. "edi", "knb-lter-bnz")
#' @param identifier (character) Data package identifier
#' @param filter (character) Filter returned revisions. Can be "newest" or "oldest"
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (character) Data package revisions
#'     
#' @details GET : https://pasta.lternet.edu/package/eml/{scope}/{identifier}
#' 
#' @export
#' 
#' @examples 
#' # All revisions
#' list_data_package_revisions("edi", "275")
#' 
#' # Newest revision
#' list_data_package_revisions("edi", "275", filter = "newest")
#' 
#' # Oldest revision
#' list_data_package_revisions("edi", "275", filter = "oldest")
#' 
list_data_package_revisions <- function(scope, 
                                        identifier, 
                                        filter = NULL, 
                                        environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/eml/",
                paste(c(scope, identifier), collapse = "/"))
  if (!is.null(filter)) {
    url <- paste0(url, "?filter=", filter)
  }
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
