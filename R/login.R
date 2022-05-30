#' Login to the EDI repository
#'
#' @param userId (character) User identifier of an EDI data repository account.
#' If using
#' @param userPass (character) Password of \code{userId}
#' @param config (character) Path to config.txt, which contains \code{userId}
#' and \code{userPass} (see details below)
#'
#' @return (character) A temporary (~10 hour) authentication token written to
#' the system variable "EDI_TOKEN".
#'
#' @note Only works when authenticating with EDI credentials. Does not work
#' when authenticating with ORCiD, GitHub, or Google credentials.
#'
#' Be careful not to accidentally share your \code{userId} and \code{userPass}.
#' Some tips to avoid this:
#' \itemize{
#'   \item Don't write code that explicitly lists your credentials.
#'   \item Don't save your workspace when exiting an R session.
#'   \item Do store your credentials as environmental variables and reference
#'   these.
#'   \item Do use \code{config} but if using version control ensure the
#'   config.txt file is listed in your .gitignore.
#' }
#' If you may have shared your credentials, please reset your password at
#' \url{https://dashboard.edirepository.org/dashboard/auth/reset_password_init}.
#'
#'
#' @details
#' If \code{userId}, \code{userPass}, and \code{config} are NULL, the console
#' will prompt for credentials.
#'
#' \code{config}: Supplying credentials in a file named config.txt facilitates
#' authentication within automated/unassisted processes. Contents of this file
#' should be new line separated and have the form "<argument> = <value>" (e.g.
#' userId = myname).
#' 
#' @family Authentication
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # Interactively at the console
#' login()
#' #> User name: "my_name"
#' #> User password: "my_secret"
#'
#' # Programmatically with function arguments
#' login(userId = "my_name", userPass = "my_secret")
#'
#' # Programmatically with a file containing userId and userPass arguments
#' login(config = paste0(tempdir(), "/config.txt"))
#' }
#'
login <- function(userId = NULL, userPass = NULL, config = NULL) {
  on.exit(rm(userId))
  on.exit(rm(userPass))
  if (is.null(userId) & is.null(userPass) & is.null(config)) {
    userId <- readline("User name: ")
    userPass <- readline("User password: ")
  } else if (!is.null(config)) {
    txt <- readLines(config, warn = FALSE)
    pattern <- "(?<==).*"
    i <- grepl("userId", txt)
    userId <- trimws(
      regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE))
    )
    i <- grepl("userPass", txt)
    userPass <- trimws(
      regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE))
    )
  }
  dn <- create_dn(userId, "EDI")
  resp <- httr::GET(
    url = paste0(base_url("production"), "/package/eml"),
    config = httr::authenticate(dn, userPass, type = "basic"),
    handle = httr::handle("")
  )
  httr::stop_for_status(resp)
  token <- httr::cookies(resp)$value
  Sys.setenv(EDI_TOKEN = token)
}
