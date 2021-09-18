#' Evaluate data package
#'
#' @param eml (character) Full path to the EML file to be evaluated
#' @param useChecksum (logical) Whether to to use an existing copy of the data entities from a previous revision of the data package (see details below).
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @param transaction (character) Transaction identifier. Use \code{check_evaluation_status()} to check if evaluation has completed and \code{read_evaluate_report()} to read the report.
#' 
#' @note User authentication is required (see \code{login()}). 
#'           
#' @details Each data entity described in \code{eml} must be accessible to the EDI Data Repository through URLs listed in the \code{eml} at the XPath ".//physical/distribution/online/url". This URL should be static and not present the EDI Data Repository with any redirects, otherwise the data entity will not be accessible.
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
evaluate_data_package <- function(eml, useChecksum = FALSE, tier = "production") {
  # TODO implement useChecsum
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/evaluate/eml")
  cookie <- bake_cookie()
  resp <- httr::POST(url, 
                     set_user_agent(), 
                     cookie, 
                     handle = httr::handle(""), 
                     body = httr::upload_file(eml))
  httr::stop_for_status(resp)
  transaction <- httr::content(resp, as = "text", encoding = "UTF-8")
  return(transaction)
}