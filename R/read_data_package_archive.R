#' Read data package archive
#'
#' @param packageId (character) Data package identifier
#' @param transaction (character) Transaction identifier
#' @param path (character) Path of directory in which the result will be written
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (.zip file) The data package archive of \code{packageId} requested by \code{transaction}
#' 
#' @export
#' 
#' @examples 
#' packageId <- "knb-lter-vcr.340.1"
#' transaction <- create_data_package_archive(packageId)
#' path <- "/Users/me/Documents"
#' read_data_package_archive(packageId, transaction, path)
#'
read_data_package_archive <- function(packageId, 
                                      transaction,
                                      path,
                                      env = "production") {
  validate_arguments(x = as.list(environment()))
  read_data_package_error(transaction, env)
  url <- paste0(url_env(env), ".lternet.edu/package/archive/eml/",
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                transaction)
  resp <- httr::GET(url, 
                    set_user_agent(), 
                    handle = httr::handle(""), 
                    httr::write_disk(paste0(path, "/", packageId, ".zip")),
                    httr::progress())
}