#' Read metadata checksum
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) A 40 character SHA-1 checksum value
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read checksum
#' checksum <- read_metadata_checksum("knb-lter-ntl.409.1")
#' checksum
#' #> [1] "c89d0ac740f65ef599c6a90619221441e20b8b6e"
#' }
read_metadata_checksum <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/metadata/checksum/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
