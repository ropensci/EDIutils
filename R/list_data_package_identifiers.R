#' List data package identifiers
#'
#' @param scope (character) Scope of data package (i.e. the first component of a \code{packageId})
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (numeric) Identifiers of data packages within a specified \code{scope}
#'
#' @export
#' 
#' @examples
#' list_data_package_identifiers("knb-lter-ble")
#' 
list_data_package_identifiers <- function(scope, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/eml/", scope)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- as.numeric(text2char(parsed))
  return(res)
}
