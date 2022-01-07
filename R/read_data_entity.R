#' Read data entity
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (raw) Raw bytes (i.e. application/octet-stream) to be parsed by a
#' reader function appropriate for the data type
#'
#' @export
#'
#' @examples
#' # Read names and IDs of data entities in package "edi.1047.1"
#' res <- read_data_entity_names(packageId = "edi.1047.1")
#' res
#'
#' # Read raw bytes of the 3rd data entity
#' raw <- read_data_entity(packageId = "edi.1047.1", entityId = res$entityId[3])
#' head(raw)
#'
#' # Parse with .csv reader
#' data <- readr::read_csv(file = raw)
#' data
read_data_entity <- function(packageId, entityId, env = "production") {
  url <- paste0(
    base_url(env), "/package/data/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  if (resp$status_code == "200") {
    res <- httr::content(resp, as = "raw", encoding = "UTF-8")
  } else {
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
  }
  return(res)
}
