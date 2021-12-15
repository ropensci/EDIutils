#' Read data entity sizes
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (data.frame) Size (in bytes) and identifiers of data entities in \code{packageId}
#' 
#' @export
#' 
#' @examples
#' read_data_entity_sizes("knb-lter-cdr.711.1")
#'
read_data_entity_sizes <- function(packageId, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(base_url(env), "/package/data/size/eml/", 
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  df <- read.csv(text = res, as.is = TRUE, header = FALSE)
  names(df) <- c("entityId", "size")
  return(df)
}
