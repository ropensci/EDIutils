#' Create data package archive (zip)
#'
#' @param packageId (character) Data package identifier
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'     
#' @return transaction (character) Transaction identifier. May be used in a subsequent call to:
#' \itemize{
#'   \item \code{read_data_package_error()} to determine the operation status
#'   \item \code{read_data_package_archive()} to obtain the Zip archive
#' }
#'
#' @export
#' 
#' @examples 
#' create_data_package_archive("knb-lter-sev.31999.1")
#'
create_data_package_archive <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/archive/eml/", 
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::POST(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(res)
}
