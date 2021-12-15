#' Read data entity name
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (character) Name of \code{entityId} in \code{packageId}
#' 
#' @export
#' 
#' @examples 
#' # Get name of first data entity in data package "knb-lter-cap.691.2"
#' packageId <- "knb-lter-cap.691.2"
#' entityIds <- list_data_entities(packageId)
#' read_data_entity_name(packageId, entityIds[1])
#'
read_data_entity_name <- function(packageId, entityId, env = "production"){
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/package/name/eml/",
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                entityId)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
