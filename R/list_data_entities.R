#' List data entities
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) Identifiers for all data entities in \code{packageId}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' entityIds <- list_data_entities("knb-lter-and.2732.7")
#' entityIds
#' #> [1] "0464a1d9262fc6e609cb0b24adb7e5ba"
#' #> [2] "cc3ade83d3655edd2ca674721a52ef46"
#' }
list_data_entities <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/data/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
