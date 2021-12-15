#' List data package scopes
#'
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (numeric) Scopes within a specified \code{env}
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
list_data_package_scopes <- function(env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/package/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
