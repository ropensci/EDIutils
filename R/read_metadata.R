#' Read metadata
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) EML metadata document.
#' 
#' See the 
#' \href{https://CRAN.R-project.org/package=emld}{emld} library 
#' for more on working with EML as a list or JSON-LD. See the 
#' \href{https://CRAN.R-project.org/package=xml2}{xml2} library 
#' for working with EML as XML.
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read metadata
#' eml <- read_metadata("edi.100.1")
#' eml
#' #> {xml_document}
#' #> <eml packageId="edi.100.1" system="https://pasta.edirepository.org"   ...
#' #> [1] <access authSystem="https://pasta.edirepository.org/authenticatio ...
#' #> [2] <dataset>\n  <alternateIdentifier system="https://doi.org">doi:10 ...
#' }
read_metadata <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/metadata/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
