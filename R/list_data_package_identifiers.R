#' List data package identifiers
#'
#' @param scope (character) Scope of data package
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (numeric) Identifiers of data packages within a specified
#' \code{scope}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List identifiers
#' identifiers <- list_data_package_identifiers("knb-lter-ble")
#' identifiers
#' #> [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 23
#' }
list_data_package_identifiers <- function(scope, env = "production") {
  url <- paste0(base_url(env), "/package/eml/", scope)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
