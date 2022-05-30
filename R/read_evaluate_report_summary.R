#' Summarize the evaluate quality report
#'
#' @param transaction (character) Transaction identifier
#' @param with_exceptions (logical) Convert quality report warnings and errors
#' to R warnings and errors
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (message/warning/error) A message listing the total number of checks
#' resulting in valid, info, warn, and error status. Exceptions are raised if
#' warnings and errors are found and \code{with_exceptions} is TRUE.
#'
#' @details Get \code{transaction} from \code{evaluate_data_package()}
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
#' login()
#'
#' # Evaluate data package
#' transaction <- evaluate_data_package(
#'   eml = paste0(tempdir(), "/edi.595.1.xml"),
#'   env = "staging"
#' )
#' transaction
#' #> [1] "evaluate_163966785813042760"
#'
#'
#' # Summarize report
#' read_evaluate_report_summary(transaction, env = "staging")
#' #> ===================================================
#' #>   EVALUATION REPORT
#' #> ===================================================
#' #>
#' #> PackageId: edi.595.1
#' #> Report Date/Time: 2021-12-16T22:49:25
#' #> Total Quality Checks: 29
#' #> Valid: 21
#' #> Info: 8
#' #> Warn: 0
#' #> Error: 0
#'
#'
#' logout()
#' }
#'
read_evaluate_report_summary <- function(transaction,
                                         with_exceptions = TRUE,
                                         env = "production") {
  qualityReport <- read_evaluate_report(transaction, env = env)
  res <- report2char(qualityReport, full = FALSE, env = env)
  message(res[1])
  if (with_exceptions) {
    any_warn <- !grepl("Warn: 0", res[1])
    any_error <- !grepl("Error: 0", res[1])
    if (any_warn) {
      warning("One or more quality checks resulted in 'warn'", call. = FALSE)
    }
    if (any_error) {
      stop("One or more quality checks resulted in 'error'", call. = FALSE)
    }
  }
}
