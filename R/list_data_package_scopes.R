#' List data package scopes
#'
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (character) All scope values extant in the data package registry.
#'
#' @export
#' 
#' @details GET : https://pasta.lternet.edu/package/eml
#' 
#' @examples 
#' list_data_package_scopes()
#'
list_data_package_scopes <- function(environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/eml")
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- read.csv(text = c("scope", parsed), as.is = TRUE)
  return(res)
}
