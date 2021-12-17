#' List data package scopes
#'
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (numeric) Scopes within a specified \code{env}
#'
#' @export
#' 
#' @examples 
#' # List scopes
#' scopes <- list_data_package_scopes()
#' scopes
#'
list_data_package_scopes <- function(env = "production") {
  url <- paste0(base_url(env), "/package/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
