#' Read data package archive
#'
#' @param packageId (character) Data package identifier
#' @param transaction (character) Transaction identifier. This parameter is 
#' DEPRECATED.
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
#' # Download zip archive
#' read_data_package_archive("knb-lter-sev.31999.1", path = tempdir())
#' #> |=============================================================| 100%
#' dir(tempdir())
#' #> [1] "knb-lter-sev.31999.1.zip"
#' }
#'
read_data_package_archive <- function(packageId,
                                      transaction,
                                      path,
                                      env = "production") {
  if (!missing(transaction)) {
    warning(
      "The 'transaction' parameter is deprecated and no longer required. ",
      "Please use this function without it.", call. = FALSE
    )
  }
  url <- paste0(
    base_url(env), "/package/download/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(
    url,
    set_user_agent(),
    handle = httr::handle(""),
    httr::write_disk(paste0(path, "/", packageId, ".zip")),
    httr::progress()
  )
}
