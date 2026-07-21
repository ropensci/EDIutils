#' Login to the EDI repository
#'
#' @param userId (character) User identifier of an EDI data repository account.
#' @param userPass (character) Password of \code{userId}
#' @param key (character) EDI-API access key.
#' @param config (character) Path to config.txt, which contains \code{userId}
#' and \code{userPass} or \code{key} (see details below)
#'
#' @return (NULL) No return value. The token or API key is written to its respective environment variable.
#'
#' @note Legacy credentials login only works when authenticating with EDI credentials. 
#' For modern token-free authentication, generate an API key from the EDI Portal 
#' and supply it as the \code{key} parameter or in your \code{config} file.
#'
#' Be careful not to accidentally share your credentials.
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
#' If \code{userId}, \code{userPass}, \code{key}, and \code{config} are NULL, the console
#' will prompt for credentials.
#'
#' \code{config}: Supplying credentials in a file named config.txt facilitates
#' authentication within automated/unassisted processes. Contents of this file
#' should be new line separated and have the form "<argument> = <value>" (e.g.
#' userId = myname or key = my_api_key).
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
#' #> EDI-API key (leave blank to use username/password): "my_api_key"
#'
#' # Programmatically with an API key
#' login(key = "my_api_key")
#'
#' # Programmatically with legacy function arguments
#' login(userId = "my_name", userPass = "my_secret")
#'
#' # Programmatically with a file containing credentials
#' login(config = paste0(tempdir(), "/config.txt"))
#' }
#'
#' @importFrom httr GET authenticate handle cookies stop_for_status
#'
login <- function(userId = NULL, userPass = NULL, key = NULL, config = NULL) {
  on.exit(rm(userId, userPass, key), add = TRUE)
  
  if (!is.null(config)) {
    txt <- readLines(config, warn = FALSE)
    pattern <- "(?<==).*"
    
    i_uid <- grepl("userId", txt)
    if (any(i_uid)) {
      userId <- trimws(regmatches(txt[i_uid], regexpr(pattern, txt[i_uid], perl = TRUE)))
    }
    
    i_pwd <- grepl("userPass", txt)
    if (any(i_pwd)) {
      userPass <- trimws(regmatches(txt[i_pwd], regexpr(pattern, txt[i_pwd], perl = TRUE)))
    }
    
    i_key <- grepl("key", txt)
    if (any(i_key)) {
      key <- trimws(regmatches(txt[i_key], regexpr(pattern, txt[i_key], perl = TRUE)))
    }
  }
  
  if (!is.null(key) && key != "") {
    Sys.setenv(EDI_API_KEY = key)
    message("Logged in with EDI-API key.")
    return(invisible(NULL))
  }
  
  if (is.null(userId) && is.null(userPass) && is.null(key)) {
    key_input <- readline("EDI-API key (leave blank to use username/password): ")
    key_input <- trimws(key_input)
    if (key_input != "") {
      Sys.setenv(EDI_API_KEY = key_input)
      message("Logged in with EDI-API key.")
      return(invisible(NULL))
    }
    
    userId <- readline("User name: ")
    userPass <- readline("User password: ")
  }
  
  if (!is.null(userId) && !is.null(userPass) && userId != "" && userPass != "") {
    dn <- .create_dn(userId, "EDI")
    resp <- httr::GET(
      url = paste0(base_url("development"), "/package/eml"),
      config = httr::authenticate(dn, userPass, type = "basic"),
      handle = httr::handle("")
    )
    httr::stop_for_status(resp)
    token_name <- httr::cookies(resp)$name
    token_value <- httr::cookies(resp)$value
    Sys.setenv(EDI_TOKEN = token_value[token_name == "edi-token"])
    try(Sys.setenv(AUTH_TOKEN = token_value[token_name == "auth-token"]), silent = TRUE) # facilitates deprecation of the "auth-token"
    message("Logged in with EDI username and password.")
  } else {
    stop("Please provide either an API key, or both userId and userPass.", call. = FALSE)
  }
  return(invisible(NULL))
}


.create_dn <- function(userId, ou = "EDI") {
  ou <- toupper(ou)
  res <- paste0("uid=", userId, ",o=", ou, ",")
  if (ou == "EDI") {
    res <- paste0(res, "dc=edirepository,dc=org")
  } else {
    res <- paste0(res, "dc=ecoinformatics,dc=org")
  }
  return(res)
}
