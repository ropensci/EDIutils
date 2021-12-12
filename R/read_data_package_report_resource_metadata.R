#' Read data package report resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#'
#' @return (xml_document) Resource metadata
#' 
#' @export
#' 
#' @examples 
#' read_data_package_report_resource_metadata("knb-lter-mcm.9129.3")
#'
read_data_package_report_resource_metadata <- function(packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/rmd/eml/",
                paste(parse_packageId(packageId), collapse = "/"))
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}