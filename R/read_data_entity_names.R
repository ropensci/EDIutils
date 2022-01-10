#' Read data entity names
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame) Names and identifiers of all data entities in
#' \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' read_data_entity_names("knb-lter-cap.691.2")
read_data_entity_names <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/name/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  df <- utils::read.csv(text = res, as.is = TRUE, header = FALSE)
  names(df) <- c("entityId", "entityName")
  return(df)
}
