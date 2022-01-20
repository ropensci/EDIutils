#' List user data packages
#'
#' @description List all data packages (including their revision values)
#' uploaded to the repository by a particular user, specified by a
#' distinguished name. Data packages that were uploaded by the specified user
#' but have since been deleted are excluded from the list.
#'
#' @param dn (character) Distinguished name of user. Create with
#' \code{create_dn()}.
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) Data package identifiers belonging to a \code{dn}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List user data packages
#' dn <- create_dn(userId = "dbjourneynorth")
#' packageIds <- list_user_data_packages(dn)
#' packageIds
#' #> [1] "edi.948.1" "edi.949.1"
#' }
list_user_data_packages <- function(dn, env = "production") {
  url <- paste0(base_url(env), "/package/user/", dn)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
