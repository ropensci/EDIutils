#' List deleted data packages
#'
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (data.frame) All document identifiers (excluding revision values) that have been deleted from the data package registry.
#' 
#' @details GET : https://pasta.lternet.edu/package/eml/deleted
#' 
#' @export
#' 
#' @examples 
#' list_deleted_data_packages()
#'
list_deleted_data_packages <- function(environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/eml/deleted")
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- read.csv(text = c("packageId", parsed), as.is = TRUE)
  return(res)
}
