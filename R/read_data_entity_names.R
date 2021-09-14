#' Read data entity names
#'
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (data.frame) Names and identifiers of all data entities in \code{packageId}
#'
#' @export
#' 
#' @examples 
#' read_data_entity_names("knb-lter-cap.691.2")
#'
read_data_entity_names <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/name/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  df <- read.csv(text = parsed, as.is = TRUE, header = FALSE)
  names(df) <- c("entityId", "entityName")
  return(df)
}