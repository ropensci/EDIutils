#' Read evaluate report
#'
#' @param transaction (character) Transaction identifier
#' @param as (character) Format of the returned report. Can be: "xml", "html",
#' or "char".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document or html_document or character) The evaluate quality
#' report document
#'
#' @note User authentication is required (see \code{login()})
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' login()
#'
#' # Evaluate data package
#' transaction <- evaluate_data_package(
#'   eml = paste0(tempdir(), "/edi.595.1.xml"),
#'   env = "staging"
#' )
#' transaction
#' #> [1] "evaluate_163966785813042760"
#'
#' # Read as HTML and write to file for a web browser view
#' qualityReport <- read_evaluate_report(
#'   transaction = transaction,
#'   as = "html",
#'   env = "staging"
#' )
#' writeLines(qualityReport, paste0(tempdir(), "/report.html"))
#'
#' # Read as character and write to file for browsing
#' qualityReport <- read_evaluate_report(
#'   transaction = transaction,
#'   as = "char",
#'   env = "staging"
#' )
#' writeLines(qualityReport, paste0(tempdir(), "/report.txt"))
#' 
#' # Read as XML
#' qualityReport <- read_evaluate_report(
#'   transaction = transaction,
#'   env = "staging"
#' )
#' qualityReport
#' #> {xml_document}
#' #> <qualityReport schemaLocation="eml://ecoinformatics.org/qualityReport ...
#' #> [1] <creationDate>2021-12-16T22:15:38</creationDate>
#' #> [2] <packageId>edi.606.1</packageId>
#' #> [3] <includeSystem>lter</includeSystem>
#' #> [4] <includeSystem>knb</includeSystem>
#' #> [5] <datasetReport>\n  <qualityCheck qualityType="metadata" system=" ...
#' #> [6] <entityReport>\n  <entityName>data.txt</entityName>\n  <qualityC ...
#'
#' logout()
#' }
#'
read_evaluate_report <- function(transaction,
                                 as = "xml",
                                 env = "production") {
  url <- paste0(
    base_url(env), "/package/evaluate/report/eml/",
    transaction
  )
  cookie <- bake_cookie()
  if (as == "html") {
    resp <- httr::GET(
      url,
      set_user_agent(),
      cookie,
      httr::accept("text/html"),
      handle = httr::handle("")
    )
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_html(res))
  } else if (as %in% c("xml", "char")) {
    resp <- httr::GET(
      url,
      set_user_agent(),
      cookie,
      handle = httr::handle("")
    )
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
