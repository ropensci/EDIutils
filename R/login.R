#' Login to the EDI repository
#'
#' @param userId (character) PASTA userId
#' @param userPass (character) Password
#' @param config (character) Path to config.txt, which contains \code{userId} and \code{userPass} (see details below)
#'
#' @return (file) A temporary (~10 hour) authentication token written to edi_token.txt within the session \code{tempdir()}.
#' 
#' @note Only works when authenticating with EDI credentials. Does not work for ORCiD, GitHub, or Google credentials.
#' 
#' @details
#' If \code{userId}, \code{userPass}, and \code{config} are NULL, the console will prompt for credentials.
#' 
#' \code{config}: Supplying credentials in a file named config.txt facilitates authentication within automated/unassisted processes. Contents of this file should be new line separated and have the form "<argument> = <value>" (e.g. userId = myname).
#' 
#' Security: Input user name and password are only held for the duration of this function call and are disposed of by \code{on.exit()}. The temporary encrypted token is written to file at the path defined by \code{tempdir()} and is removed at close of the users R session.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' # Login with arguments
#' login("myname", "mysecret")
#' 
#' # Login with config.txt
#' login("/Users/me/Documents/config.txt")
#' 
#' # Login at console
#' login()
#' }
#' 
login <- function(userId = NULL, userPass = NULL, config = NULL) {
  validate_arguments(x = as.list(environment()))
  on.exit(rm(userId))
  on.exit(rm(userPass))
  if (is.null(userId) & is.null(userPass) & is.null(config)) {
    userId <- readline("User name: ")
    userPass <- readline("User password: ")
  } else if (!is.null(config)) {
    txt <- readLines(config, warn = FALSE)
    pattern <- "(?<==).*"
    i <- grepl("userId", txt)
    userId <- trimws(regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE)))
    i <- grepl("userPass", txt)
    userPass <- trimws(regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE)))
  }
  dn <- create_dn(userId, "EDI")
  resp <- httr::GET(url = paste0(url_env("production"), ".lternet.edu/package/eml"),
                    config = httr::authenticate(dn, userPass, type = "basic"),
                    handle = httr::handle(""))
  httr::stop_for_status(resp)
  token <- httr::cookies(resp)$value
  writeLines(token, paste0(tempdir(), "/edi_token.txt"))
}