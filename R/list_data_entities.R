#' List data entities
#' 
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return (character) Identifiers for all data entities in \code{packageId}
#' 
#' @export
#' 
#' @examples
#' list_data_entities("knb-lter-and.2726.6")
#'
list_data_entities <- function(packageId, env = "production") {
  url <- paste0(base_url(env), "/package/data/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
