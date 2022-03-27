#' Get provenance metadata
#'
#' @description Generates the provenance metadata of a source data package
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Provenance metadata of \code{packageId}, representing
#' a <methodStep> element that can be inserted into the <methods> section of a
#' dependent data package. 
#' 
#' See the 
#' \href{https://CRAN.R-project.org/package=emld}{emld} library 
#' for more on working with EML as a list or JSON-LD. See the 
#' \href{https://CRAN.R-project.org/package=xml2}{xml2} library 
#' for working with EML as XML.
#' 
#' @family Provenance
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' methodStep <- get_provenance_metadata("knb-lter-pal.309.1")
#' methodStep
#' #> {xml_document}
#' #> <methodStep>
#' #> [1] <description>\n  <para>This method step describes provenance-based ...
#' #> [2] <dataSource>\n  <title>Stable isotope composition (d18O) of seawat ...
#' }
get_provenance_metadata <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/provenance/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
