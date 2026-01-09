#' List user data packages
#'
#' @description List all data packages (including their revision values)
#' uploaded to the repository by a particular user, specified by a
#' distinguished name. Data packages that were uploaded by the specified user
#' but have since been deleted are excluded from the list.
#'
#' @param edi_id (character) The EDI ID of the user. An EDI ID can be obtained 
#' from the EDI Identity and Access Manager 
#' (\url{https://auth.edirepository.org/auth/ui/signin}).
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) Data package identifiers belonging to a 
#'   \code{edi_id}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List user data packages
#' edi_id <- "EDI-543afa80c859825d35d37d9111c24a4a65a0ff9e"
#' packageIds <- list_user_data_packages(edi_id)
#' packageIds
#' #> [1] "edi.948.1" "edi.949.1"
#' }
list_user_data_packages <- function(edi_id, env = "production") {
  url <- paste0(base_url(env), "/package/user/", edi_id)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
