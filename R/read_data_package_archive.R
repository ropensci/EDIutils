#' Read data package archive
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param transaction (character) Transaction identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (.zip) The data package archive of \code{packageId}
#' 
#' @export
#' 
#' @examples 
#'
read_data_package_archive <- function(packageId, 
                                      transaction, 
                                      tier = "production") {
  # TODO redirect output to file?
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(tier), ".lternet.edu/package/archive/eml/",
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                transaction)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  # parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  # return(parsed)
}