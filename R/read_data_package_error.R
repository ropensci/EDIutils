#' Read data package error
#'
#' @param transaction (character) Transaction identifier
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return An error is returned if an error occurred while processing the request, otherwise \code{NULL} is returned if no error was encountered or if processing is still underway.
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' # Returns an error because of malformed packageId
#' path <- "/Users/me/Documents/bad_id.xml"
#' transaction <- evaluate_data_package(path)
#' read_data_package_error(transaction)
#' 
#' # Does not return an error
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' transaction <- evaluate_data_package(path)
#' read_data_package_error(transaction)
#' }
#'
read_data_package_error <- function(transaction, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/error/eml/", transaction)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  if (resp$status_code != "404") {
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    stop(res, call. = FALSE)
  }
}