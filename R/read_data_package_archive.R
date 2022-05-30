#' Read data package archive
#'
#' @param packageId (character) Data package identifier
#' @param transaction (character) Transaction identifier
#' @param path (character) Path of directory in which the result will be written
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (.zip file) The data package archive of \code{packageId} requested
#' by \code{transaction}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # Create zip archive
#' packageId <- "knb-lter-sev.31999.1"
#' transaction <- create_data_package_archive(packageId)
#' transaction
#' #> [1] "archive_knb-lter-sev.31999.1_16396683904724129"
#'
#' # Check creation status
#' read_data_package_error(transaction)
#'
#' # Download zip archive
#' read_data_package_archive(packageId, transaction, path = tempdir())
#' #> |=============================================================| 100%
#' dir(tempdir())
#' #> [1] "knb-lter-sev.31999.1.zip"
#' }
#'
read_data_package_archive <- function(packageId,
                                      transaction,
                                      path,
                                      env = "production") {
  url <- paste0(
    base_url(env), "/package/archive/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    transaction
  )
  resp <- httr::GET(
    url,
    set_user_agent(),
    handle = httr::handle(""),
    httr::write_disk(paste0(path, "/", packageId, ".zip")),
    httr::progress()
  )
}
