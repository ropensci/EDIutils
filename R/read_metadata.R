#' Read metadata
#'
#' @param packageId (character) Data package identifier
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) EML document
#' 
#' @export
#' 
#' @examples 
#' read_metadata("edi.100.1")
#'
read_metadata <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/metadata/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
