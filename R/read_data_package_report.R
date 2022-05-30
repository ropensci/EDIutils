#' Read data package report
#'
#' @param packageId (character) Data package identifier
#' @param as (character) Format of the returned report. Can be: "xml",
#' "html", or "char".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Data package report
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read as XML
#' qualityReport <- read_data_package_report("knb-lter-knz.260.4")
#' qualityReport
#' #> {xml_document}
#' #> <qualityReport schemaLocation="eml://ecoinformatics.org/qualityReport ...
#' #>  [1] <creationDate>2020-02-04T16:38:38</creationDate>
#' #>  [2] <packageId>knb-lter-knz.260.4</packageId>
#' #>  [3] <includeSystem>lter</includeSystem>
#' #>  [4] <includeSystem>knb</includeSystem>
#' #>  [5] <datasetReport>\n  <qualityCheck qualityType="metadata" system=" ...
#' #>  [6] <entityReport>\n  <entityName>GIS600</entityName>\n  <qualityChe ...
#' #>  [7] <entityReport>\n  <entityName>KMZGIS600</entityName>\n  <quality ...
#' #>  [8] <entityReport>\n  <entityName>GIS605</entityName>\n  <qualityChe ...
#' #>  [9] <entityReport>\n  <entityName>KMZGIS605</entityName>\n  <quality ...
#' #> [10] <entityReport>\n  <entityName>GIS610</entityName>\n  <qualityChe ...
#' #> ...
#' 
#' # Read as HTML
#' qualityReport <- read_data_package_report(
#'  packageId = "knb-lter-knz.260.4",
#'  as = "html"
#' )
#' qualityReport
#' #> {html_document}
#' #> <html>
#' #> [1] <body><table xmlns:qr="eml://ecoinformatics.org/qualityReport"><t ...
#' 
#' # Read as character
#' qualityReport <- read_data_package_report(
#'  packageId = "knb-lter-knz.260.4",
#'  as = "char"
#' )
#' # writeLines(qualityReport, paste0(tempdir(), "/report.txt"))
#' }
read_data_package_report <- function(packageId,
                                     as = "xml",
                                     env = "production") {
  url <- paste0(
    base_url(env), "/package/report/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  if (as == "html") {
    resp <- httr::GET(
      url,
      set_user_agent(),
      httr::accept("text/html"),
      handle = httr::handle("")
    )
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_html(res))
  } else if (as %in% c("xml", "char")) {
    resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    if (as == "xml") {
      return(xml2::read_xml(res))
    } else if (as == "char") {
      char <- report2char(xml2::read_xml(res), env = env)
      return(char)
    }
  }
}
