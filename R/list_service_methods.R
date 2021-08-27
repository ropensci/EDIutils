#' List service methods
#'
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (character) A simple list of web service methods supported by the Data Package Manager web service.
#' 
#' @export
#' 
#' @examples 
#' # All service methods in production
#' list_service_methods()
#' 
#' # All service methods in staging
#' list_service_methods("staging")
#' 
#' #' # All service methods in development
#' list_service_methods("development")
#'
list_service_methods <- function(tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/service-methods")
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
