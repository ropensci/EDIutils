#' Read data entity checksum
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) A 40-character SHA-1 checksum value of \code{entityId}
#' in \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' # List data entities
#' entityIds <- list_data_entities(packageId = "knb-lter-ble.1.7")
#' entityIds
#'
#' # Read checksum
#' checksum <- read_data_entity_checksum(
#'   packageId = "knb-lter-ble.1.7",
#'   entityId = entityIds[1]
#' )
#' checksum
read_data_entity_checksum <- function(packageId, entityId, env = "production") {
  pkg <- parse_packageId(packageId)
  url <- paste0(
    base_url(env), "/package/data/checksum/eml/",
    paste(pkg, collapse = "/"), "/", entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
