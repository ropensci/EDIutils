#' List deleted data packages
#'
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) All data packages (excluding revision values) that have
#' been deleted from the data package registry.
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' # List deleted data packages
#' deleted <- list_deleted_data_packages()
#' head(deleted)
list_deleted_data_packages <- function(env = "production") {
  url <- paste0(base_url(env), "/package/eml/deleted")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
