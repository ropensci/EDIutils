#' List data package identifiers
#'
#' @param scope (character) Scope of data package
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (numeric) Identifiers of data packages within a specified \code{scope}
#'
#' @export
#' 
#' @examples
#' list_data_package_identifiers("knb-lter-ble")
#' 
list_data_package_identifiers <- function(scope, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/package/eml/", scope)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
