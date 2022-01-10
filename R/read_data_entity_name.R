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
#' # List entities
#' entityIds <- list_data_entities(packageId = "knb-lter-cap.691.2")
#' entityIds
#'
#' # Read name
#' entityName <- read_data_entity_name(
#'   packageId = "knb-lter-cap.691.2",
#'   entityId = entityIds[1]
#' )
#' entityName
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
