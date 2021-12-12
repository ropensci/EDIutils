#' List deleted data packages
#'
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (character) All data packages (excluding revision values) that have been deleted from the data package registry.
#' 
#' @export
#' 
#' @examples 
#' # All packages deleted from production
#' list_deleted_data_packages()
#' 
#' # All packages deleted from staging
#' list_deleted_data_packages("staging")
#' 
#' # All packages deleted from development
#' list_deleted_data_packages("development")
#'
list_deleted_data_packages <- function(tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/eml/deleted")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
