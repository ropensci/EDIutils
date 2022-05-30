#' Read data package error
#'
#' @param transaction (character) Transaction identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return An error is returned if an error occurred while processing the
#' request, otherwise \code{NULL} is returned if no error was encountered or if
#' processing is still underway.
#'
#' @note User authentication is required (see \code{login()})
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
read_data_package_error <- function(transaction, env = "production") {
  if (grepl("__", transaction)) {
    transaction <- unlist(strsplit(transaction, "__"))[1]
  }
  url <- paste0(base_url(env), "/package/error/eml/", transaction)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  if (resp$status_code %in% c("200", "400", "401", "405", "500")) {
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    stop(res, call. = FALSE)
  }
}
