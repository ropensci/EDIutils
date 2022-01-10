#' Logout of the EDI repository
#'
#' @details Removes the temporary authentication token system variable
#' "EDI_TOKEN".
#' 
#' @family Authentication
#'
#' @export
#'
#' @examples
#' \dontrun{
#' logout()
#' }
#'
logout <- function() {
  suppressWarnings(Sys.unsetenv("EDI_TOKEN"))
}
