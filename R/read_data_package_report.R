#' Read data package report
#'
#' @param packageId (character) Data package identifier
#' @param frmt (character) Format of the returned report. Can be: "xml",
#' "html", or "char".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Data package report
#'
#' @export
#'
#' @examples
#' # Read as XML
#' qualityReport <- read_data_package_report("knb-lter-knz.260.4")
#' qualityReport
#'
#' # Read as HTML
#' qualityReport <- read_data_package_report(
#'   packageId = "knb-lter-knz.260.4",
#'   frmt = "html"
#' )
#' qualityReport
#'
#' # Read as character
#' qualityReport <- read_data_package_report(
#'   packageId = "knb-lter-knz.260.4",
#'   frmt = "char"
#' )
#' # writeLines(qualityReport, "./data/report.txt"))
read_data_package_report <- function(packageId,
                                     frmt = "xml",
                                     env = "production") {
  url <- paste0(
    base_url(env), "/package/report/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  if (frmt == "html") {
    resp <- httr::GET(
      url,
      set_user_agent(),
      httr::accept("text/html"),
      handle = httr::handle("")
    )
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_html(res))
  } else if (frmt %in% c("xml", "char")) {
    resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    if (frmt == "xml") {
      return(xml2::read_xml(res))
    } else if (frmt == "char") {
      char <- report2char(xml2::read_xml(res), env = env)
      return(char)
    }
  }
}
