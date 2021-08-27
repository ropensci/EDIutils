#' List data package scopes
#'
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (numeric) Scopes within a specified \code{tier}
#'
#' @export
#' 
#' @examples 
#' # All scopes in production
#' list_data_package_scopes()
#' 
#' # All scopes in staging
#' list_data_package_scopes("staging")
#' 
#' #' # All scopes in development
#' list_data_package_scopes("development")
#'
list_data_package_scopes <- function(tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/eml")
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
