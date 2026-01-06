#' Logout of the EDI repository
#'
#' @details Removes the temporary authentication token system variables
#' "EDI_TOKEN" and "AUTH_TOKEN".
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
  suppressWarnings(Sys.unsetenv("AUTH_TOKEN"))
}
