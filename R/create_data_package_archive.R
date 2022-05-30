#' Create data package archive (zip)
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return transaction (character) Transaction identifier. May be used in a
#' subsequent call to:
#' \itemize{
#'   \item \code{read_data_package_error()} to determine the operation status
#'   \item \code{read_data_package_archive()} to obtain the Zip archive
#' }
#' 
#' @family Miscellaneous
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
create_data_package_archive <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/archive/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::POST(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(res)
}
