#' Read data package error
#'
#' @param transaction (character) Transaction identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (character) Result of operation
#' 
#' @export
#' 
#' @examples 
#'
read_data_package_error <- function(transaction, tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/package/error/eml/", transaction)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
