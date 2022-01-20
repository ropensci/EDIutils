#' Summarize the data package quality report
#'
#' @param packageId (character) Data package identifier
#' @param with_exceptions (logical) Convert quality report warnings and errors
#' to R warnings and errors
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (message/warning/error) A message listing the total number of checks
#' resulting in valid, info, warn, and error status. Exceptions are raised if
#' warnings and errors are found and \code{with_exceptions} is TRUE.
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read report summary
#' read_data_package_report_summary("knb-lter-knz.260.4")
#' #> ===================================================
#' #>   EVALUATION REPORT
#' #> ===================================================
#' #>   
#' #> PackageId: knb-lter-knz.260.4
#' #> Report Date/Time: 2020-02-04T16:38:38
#' #> Total Quality Checks: 213
#' #> Valid: 139
#' #> Info: 73
#' #> Warn: 1
#' #> Error: 0
#' #> 
#' #> 
#' #> Warning message:
#' #> One or more quality checks resulted in 'warn' 
#' }
read_data_package_report_summary <- function(packageId,
                                             with_exceptions = TRUE,
                                             env = "production") {
  qualityReport <- read_data_package_report(packageId, env = env)
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
