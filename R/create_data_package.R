#' Create data package
#'
#' @param eml (character) Full path to an EML file describing the data package
#' to be created
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return transaction (character) Transaction identifier. May be used in a
#' subsequent call to \code{check_status_create()} to determine the operation
#' status
#'
#' @details Each data entity described in \code{eml} must be accompanied by a
#' web accessible URL at the EML XPath ".//physical/distribution/online/url".
#' The EDI data repository downloads the data entities via this URL. The URLs
#' must be static and not have any redirects otherwise the data entities will
#' not be downloaded.
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
#' # Create data package
#' transaction <- create_data_package(
#'   eml = paste0(tempdir(), "/edi.595.1.xml"),
#'   env = "staging"
#' )
#' transaction
#' #> [1] "create_163966765080210573__edi.595.1"
#'
#' # Check creation status
#' status <- check_status_create(
#'   transaction = transaction,
#'   env = "staging"
#' )
#' status
#' #> [1] TRUE
#'
#' logout()
#' }
#'
create_data_package <- function(eml, env = "production") {
  url <- paste0(base_url(env), "/package/eml")
  cookie <- bake_cookie()
  resp <- httr::POST(
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
