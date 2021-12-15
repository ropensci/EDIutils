#' Evaluate data package
#' 
#' @param eml (character) Full path to an EML file describing the data package to be evaluated
#' @param useChecksum (logical) Use data entities from a previous version of the data package? See details below.
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return transaction (character) Transaction identifier. May be used in a subsequent call to:
#' \itemize{
#'   \item \code{check_status_evaluate()} to determine the operation status
#'   \item \code{read_evaluate_report()} to read the evaluation report
#'   \item \code{summarize_evaluate_report()} to summarize the evaluation report and raise exceptions
#' }
#' 
#' @note User authentication is required (see \code{login()})
#'           
#' @details Each data entity described in \code{eml} must be accompanied by a web accessible URL at the EML XPath ".//physical/distribution/online/url". The EDI data repository downloads the data entities via this URL. The URLs must be static and not have any redirects otherwise the data entities will not be downloaded.
#' 
#' An optional query parameter, "useChecksum", can be appended to the URL. When specified, the useChecksum query parameter directs the repository to determine whether it can use an existing copy of a data entity from a previous revision of the data package based on matching a metadata-documented checksum value (MD5 or SHA-1) to the checksum of the existing copy. If a match is found, the repository will skip the upload of the data entity from the remote URL and instead use its matching copy. Specifying "useChecksum" can save time by eliminating data uploads, but clients should take care to ensure that metadata-documented checksum values are accurate and up to date.
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' evaluate_data_package(path)
#' }
#'
evaluate_data_package <- function(eml, useChecksum = FALSE, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/package/evaluate/eml")
  if (useChecksum) {
    url <- paste0(url, "?useChecksum")
  }
  cookie <- bake_cookie()
  resp <- httr::POST(url, 
                     set_user_agent(), 
                     cookie, 
                     handle = httr::handle(""), 
                     body = httr::upload_file(eml))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(res)
}
