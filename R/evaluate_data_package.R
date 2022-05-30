#' Evaluate data package
#'
#' @param eml (character) Full path to an EML file describing the data package
#' to be evaluated
#' @param useChecksum (logical) Use data entities from a previous version of
#' the data package? See details below.
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return transaction (character) Transaction identifier. May be used in a
#' subsequent call to:
#' \itemize{
#'   \item \code{check_status_evaluate()} to determine the operation status
#'   \item \code{read_evaluate_report()} to read the evaluation report
#'   \item \code{read_evaluate_report_summary()} to summarize the evaluation
#'   report and raise exceptions
#' }
#'
#' @note User authentication is required (see \code{login()})
#'
#' @details Each data entity described in \code{eml} must be accompanied by a
#' web accessible URL at the EML XPath ".//physical/distribution/online/url".
#' The EDI data repository downloads the data entities via this URL. The URLs
#' must be static and not have any redirects otherwise the data entities will
#' not be downloaded.
#'
#' An optional query parameter, "useChecksum", can be appended to the URL. When
#' specified, the useChecksum query parameter directs the repository to
#' determine whether it can use an existing copy of a data entity from a
#' previous revision of the data package based on matching a
#' metadata-documented checksum value (MD5 or SHA-1) to the checksum of the
#' existing copy. If a match is found, the repository will skip the upload of
#' the data entity from the remote URL and instead use its matching copy.
#' Specifying "useChecksum" can save time by eliminating data uploads, but
#' clients should take care to ensure that metadata-documented checksum values
#' are accurate and up to date.
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
# Evaluate data package
#' transaction <- evaluate_data_package(
#'   eml = paste0(tempdir(), "/edi.595.1.xml"),
#'   env = "staging"
#' )
#' transaction
#' #> [1] "evaluate_163966785813042760"
#'
#' # Check evaluation status
#' status <- check_status_evaluate(transaction, env = "staging")
#' status
#' #> [1] TRUE
#'
#' # Read evaluation report
#' report <- read_evaluate_report(transaction, env = "staging")
#' report
#' #> {xml_document}
#' #> <qualityReport schemaLocation="eml://ecoinformatics.org/qualityReport ...
#' #> [1] <creationDate>2021-12-15T17:46:33</creationDate>
#' #> [2] <packageId>edi.595.1</packageId>
#' #> [3] <includeSystem>lter</includeSystem>
#' #> [4] <includeSystem>knb</includeSystem>
#' #> [5] <datasetReport>\n  <qualityCheck qualityType="metadata" system=" ...
#' #> [6] <entityReport>\n  <entityName>data.txt</entityName>\n  <qualityC ...
#'
#' # Summarize evaluation report
#' read_evaluate_report_summary(transaction, env = "staging")
#' #> ===================================================
#' #>   EVALUATION REPORT
#' #> ===================================================
#' #>
#' #> PackageId: edi.595.1
#' #> Report Date/Time: 2021-12-15T17:46:33
#' #> Total Quality Checks: 29
#' #> Valid: 21
#' #> Info: 8
#' #> Warn: 0
#' #> Error: 0
#'
#' logout()
#' }
#'
evaluate_data_package <- function(eml,
                                  useChecksum = FALSE,
                                  env = "production") {
  url <- paste0(base_url(env), "/package/evaluate/eml")
  if (useChecksum) {
    url <- paste0(url, "?useChecksum")
  }
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
  return(res)
}
