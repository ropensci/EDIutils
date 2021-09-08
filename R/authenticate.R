#' Authenticate with EDI credentials
#'
#' @param config (character) Path to config.txt containing a user name and password (see details below). If NULL, the console will prompt for this information.
#'
#' @return (file) A temporary (~18 hour) authentication token written to edi_token.txt within the session \code{tempdir()}.
#' 
#' @details
#' \code{config}: Supplying credentials in a file named config.txt, and containing the lines "userId = NAME" and "userPass = PASS", facilitates authentication within automated/unassisted processes.
#' 
#' Security: Input user name and password are only held for the duration of this function call and are disposed of by \code{on.exit()}. The temporary encrypted token is written to file at the path defined by \code{tempdir()} and is removed at close of the users R session.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' # Authenticate at console
#' authenticate()
#' 
#' # Authenticate with config.txt
#' authenticate("/Users/me/Documents/config.txt")
#' }
#' 
authenticate <- function(config = NULL) {
  on.exit(rm(name))
  on.exit(rm(pass))
  if (!is.null(config)) {
    txt <- readLines(config, warn = FALSE)
    pattern <- "(?<==).*"
    i <- grepl("userId", txt)
    name <- trimws(regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE)))
    if (length(name) == 0) {
      stop("Cannot parse 'userId' from config.txt.", call. = FALSE)
    }
    i <- grepl("userPass", txt)
    pass <- trimws(regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE)))
    if (length(name) == 0) {
      stop("Cannot parse 'userPass' from config.txt.", call. = FALSE)
    }
  } else {
    name <- readline("User name: ")
    pass <- readline("User password: ")
  }
  dn <- construct_dn(userId = name, ou = "EDI")
  resp <- httr::GET("https://pasta.lternet.edu/package/eml", 
                    httr::authenticate(dn, pass, type = "basic"))
  httr::stop_for_status(resp)
  token <- httr::cookies(r)$value
  writeLines(token, paste0(tempdir(), "/edi_token.txt"))
}