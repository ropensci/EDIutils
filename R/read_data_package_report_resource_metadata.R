#' Read data package report resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Report resource metadata
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read resource metadata
#' resourceMetadata <- read_data_package_report_resource_metadata(
#'   packageId = "knb-lter-mcm.9129.3"
#' )
#' }
read_data_package_report_resource_metadata <- function(packageId,
                                                       as = "data.frame",
                                                       env = "production") {
  url <- paste0(
    base_url(env), "/package/rmd/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
