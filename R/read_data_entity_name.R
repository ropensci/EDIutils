#' Read data entity name
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) Name of \code{entityId} in \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List entities
#' entityIds <- list_data_entities(packageId = "knb-lter-cap.691.2")
#' entityIds
#' #> [1] "f6e4efd0b04aea3860724824ca05c5dd"
#' #> [2] "d2263480e75cc7888b41928602cda4c6"
#' #> [3] "d5cb83e4556408e48f636157e4dee49e"
#' 
#' # Read name
#' entityName <- read_data_entity_name(
#'  packageId = "knb-lter-cap.691.2",
#'  entityId = entityIds[1]
#' )
#' entityName
#' #> [1] "691_arthropods_00742cd00ab0d3d02337e28d1c919654.csv"
#' }
read_data_entity_name <- function(packageId, entityId, env = "production") {
  url <- paste0(
    base_url(env), "/package/name/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
