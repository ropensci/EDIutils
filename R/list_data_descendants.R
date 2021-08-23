#' List data descendants
#' 
#' @description Data descendants are data packages that are known to be derived, in whole or in part, from the specified source data package.
#' 
#' @param scope (character) Data package scope
#' @param identifier (character) Data package identifier
#' @param revision (character) Data package revision
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development".
#' @param output (character) Can be: "xml_document" or "data.frame".
#' 
#' @return (xml_document or data.frame) Data descendant(s) packageId, title, and url
#' 
#' @details GET : https://pasta.lternet.edu/package/descendants/eml/{scope}/{identifier}/{revision}
#' 
#' @export
#' 
#' @examples 
#' list_data_descendants("knb-lter-bnz", "501", "17")
#'
list_data_descendants <- function(scope, identifier, revision, 
                                  environment = "production", 
                                  output = "xml_document") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/descendants/eml/",
                paste(c(scope, identifier, revision), collapse = "/"))
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  if (output == "data.frame") {
    return(xml2df(parsed))
  } else {
    return(parsed)
  }
}
