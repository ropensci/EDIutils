#' List data descendants
#'
#' @description Data descendants are data packages that are known to be
#' derived, in whole or in part, from the specified source data package.
#'
#' @param packageId (character) Data package identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Descendants of \code{packageId}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List descendants
#' dataDescendants <- list_data_descendants("knb-lter-bnz.501.17")
#' }
list_data_descendants <- function(packageId, 
                                  as = "data.frame", 
                                  env = "production") {
  url <- paste0(
    base_url(env), "/package/descendants/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
