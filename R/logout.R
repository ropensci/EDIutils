#' Logout of the EDI repository
#'
#' @details Removes the temporary authentication token system variable "EDI_TOKEN".
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