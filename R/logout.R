#' Logout of the EDI repository
#'
#' @details Removes the temporary authentication token from the path defined by \code{tempdir()}.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' logout()
#' }
#' 
logout <- function() {
  token_file <- paste0(tempdir(), "/edi_token.txt")
  invisible(suppressWarnings(file.remove(token_file)))
}