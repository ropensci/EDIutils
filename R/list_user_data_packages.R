#' List user data packages
#'
#' @description List all data packages (including their revision values) uploaded to the repository by a particular user, specified by a distinguished name. Data packages that were uploaded by the specified user but have since been deleted are excluded from the list.
#'
#' @param dn (character) Distinguished name of user. Use \code{construct_dn()} to create input to this argument.
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (character) Data package identifiers belonging to a \code{dn}
#'
#' @export
#' 
#' @examples 
#' # List all data packages uploaded by user "dbjourneynorth" who is apart of the "EDI" organizational unit
#' dn <- construct_dn("dbjourneynorth", "EDI")
#' list_user_data_packages(dn)
#' 
list_user_data_packages <- function(dn, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/user/", dn)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- text2char(parsed)
  return(res)
}