#' Check data package update status
#'
#' @param transaction (character) Transaction identifier
#' @param wait (logical) Wait for evaluation to complete? See details below.
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (logical) TRUE if the update has completed, FALSE if in progress,
#' and error if an error was encountered while processing the request
#'
#' @note User authentication is required (see \code{login()})
#'
#' @details If \code{wait = TRUE}, then the function will enter a "while" loop
#' checking every 2 seconds for the completed evaluation report. If
#' \code{wait = FALSE}, then the function will only check once and return the
#' result.
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
check_status_update <- function(transaction, wait = TRUE, env = "production") {
  packageId <- unlist(strsplit(transaction, "__"))[2]
  transaction <- unlist(strsplit(transaction, "__"))[1]
  if (wait) {
    while (TRUE) {
      Sys.sleep(2)
      read_data_package_error(transaction, env)
      url <- paste0(
        base_url(env), "/package/report/eml/",
        paste(parse_packageId(packageId), collapse = "/")
      )
      cookie <- bake_cookie()
      resp <- httr::GET(
        url,
        set_user_agent(),
        cookie,
        handle = httr::handle("")
      )
      if (resp$status_code == "200") {
        return(TRUE)
      }
    }
  } else {
    read_data_package_error(transaction, env)
    url <- paste0(
      base_url(env), "/package/report/eml/",
      paste(parse_packageId(packageId), collapse = "/")
    )
    cookie <- bake_cookie()
    resp <- httr::GET(
      url,
      set_user_agent(),
      cookie,
      handle = httr::handle("")
    )
    if (resp$status_code == "200") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}
