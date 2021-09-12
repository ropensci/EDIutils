#' Create data package archive (zip)
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'     
#' @return (character) A transaction identifier
#' 
#' @details The transaction identifier may be used in a subsequent call to \code{read_data_package_error()} to determine the operation status or to \code{read_data_package_archive()} to obtain the Zip archive.
#'
#' @export
#' 
#' @examples 
#'
create_data_package_archive <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/package/archive/eml/", 
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::POST(url, set_user_agent(), handle = httr::handle(""))
  transaction <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(as.numeric(res))
}
