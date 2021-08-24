#' List service methods
#'
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (data.frame) A simple list of web service methods supported by the Data Package Manager web service.
#' 
#' @details GET : https://pasta.lternet.edu/package/service-methods
#' 
#' @export
#' 
#' @examples 
#' list_service_methods()
#'
list_service_methods <- function(environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/service-methods")
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
