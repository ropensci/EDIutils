#' Read data package error
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param transaction (character) Transaction identifier returned for each data package evaluate, upload, and delete operation
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (character) Data package error
#' 
#' @export
#' 
#' @examples 
#'
read_data_package_error <- function(packageId, transaction, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/error/eml/", 
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}
