#' Logout of the EDI repository
#'
#' @details Removes the temporary authentication token system variable
#' "EDI_TOKEN".
#' 
#' @return (NULL) No return value.
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
