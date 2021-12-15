#' Read data entity
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (raw) Raw bytes (i.e. application/octet-stream) to be parsed by a reader function appropriate for the data type
#' 
#' @export
#' 
#' @examples
#' # Get raw bytes of a .csv and use parser of choice
#' packageId <- "edi.993.1"
#' entityId <- list_data_entities(packageId)
#' raw <- read_data_entity(packageId, entityId)
#' data <- readr::read_csv(raw)
#'
read_data_entity <- function(packageId, entityId, env = "production") {
  url <- paste0(base_url(env), "/package/data/eml/", 
                paste(parse_packageId(packageId), collapse = "/"), "/", 
                entityId)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  if (resp$status_code == "200") {
    res <- httr::content(resp, as = "raw", encoding = "UTF-8")
  } else {
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
  }
  return(res)
}
