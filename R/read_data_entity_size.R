#' Read data entity size
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (numeric) Size, in bytes, of \code{entityId} in \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List data entities
#' entityIds <- list_data_entities(packageId = "knb-lter-cdr.711.1")
#' entityIds
#' #> [1] "c61703839eac9a641ea0c3c69dc3345b"
#' 
#' # Read size
#' size <- read_data_entity_size(
#'  packageId = "knb-lter-cdr.711.1",
#'  entityId = entityIds
#' )
#' size
#' #> [1] 707094
#' }
read_data_entity_size <- function(packageId, entityId, env = "production") {
  url <- paste0(
    base_url(env), "/package/data/size/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
