#' Read metadata Dublin Core
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Dublin Core metadata.
#' 
#' See the 
#' \href{https://CRAN.R-project.org/package=xml2}{xml2} library 
#' for more on working with XML.
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read dc metadata
#' dc <- read_metadata_dublin_core("knb-lter-nes.10.1")
#' dc
#' #> {xml_document}
#' #> <dc schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http: ...
#' #> [1] <dc:type/>
#' #> [2] <dc:identifier/>
#' }
read_metadata_dublin_core <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/metadata/dc/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
