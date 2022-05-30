#' Update data package
#'
#' @param eml (character) Full path to an EML file describing the data package
#' to be updated
#' @param useChecksum (logical) Use data entities from a previous version of
#' the data package? See details below.
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return transaction (character) Transaction identifier. May be used in a
#' subsequent call to \code{check_status_update()} to determine the operation
#' status
#'
#' @details Each data entity described in \code{eml} must be accompanied by a
#' web accessible URL at the XPath ".//physical/distribution/online/url". The
#' EDI data repository uses these links to download the data entities. The URLs
#' must be static and not have any redirects otherwise the data entities will
#' not be downloadable.
#'
#' @note User authentication is required (see \code{login()})
#' 
#' @family Evaluation and Upload
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' login()
#'
#' # Update data package
#' transaction <- update_data_package(
#'   eml = paste0(tempdir(), "/edi.595.2.xml"),
#'   env = "staging"
#' )
#' transaction
#' #> [1] "update_edi.595_163966788658131920__edi.595.2"
#'
#' # Check update status
#' status <- check_status_update(
#'   transaction = transaction,
#'   env = "staging"
#' )
#' status
#' #> [1] TRUE
#'
#' logout()
#' }
#'
update_data_package <- function(eml, useChecksum = FALSE, env = "production") {
  scope <- unlist(strsplit(basename(eml), "\\."))[1]
  identifier <- unlist(strsplit(basename(eml), "\\."))[2]
  url <- paste0(base_url(env), "/package/eml/", scope, "/", identifier)
  if (useChecksum) {
    url <- paste0(url, "?useChecksum")
  }
  cookie <- bake_cookie()
  resp <- httr::PUT(
    url,
    set_user_agent(),
    cookie,
    handle = httr::handle(""),
    body = httr::upload_file(eml)
  )
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  packageId <- tools::file_path_sans_ext(basename(eml))
  res <- paste0(res, "__", packageId)
  return(res)
}
