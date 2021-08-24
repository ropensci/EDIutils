#' List user data packages
#'
#' @description List all data packages (including their revision values) uploaded to the repository by a particular user, specified by a distinguished name. Data packages that were uploaded by the specified user but have since been deleted are excluded from the list.
#'
#' @param dn (character) Distinguished name (e.g. "uid=dbjourneynorth,o=EDI,dc=edirepository,dc=org"). Use \code{get_distinguished_name()} to create input to \code{dn}.
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (character) Data packages uploaded by a distinguished name.
#'
#' @details GET : https://pasta.lternet.edu/package/user/{dn}
#'
#' @export
#' 
#' @examples 
#' # List all (undeleted) data packages uploaded by user "dbjourneynorth" under the organizational unit "EDI"
#' list_user_data_packages(get_distinguished_name("dbjourneynorth", "EDI"))
list_user_data_packages <- function(dn, environment = "production"){
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/user/", dn)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- read.csv(text = c("packageId", parsed), as.is = TRUE)
  return(res)
}