#' List service methods
#'
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (character) A simple list of web service methods supported by the Data Package Manager web service
#' 
#' @export
#' 
#' @examples 
#' # All service methods
#' services <- list_service_methods()
#' services
#'
list_service_methods <- function(env = "production") {
  url <- paste0(base_url(env), "/package/service-methods")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
