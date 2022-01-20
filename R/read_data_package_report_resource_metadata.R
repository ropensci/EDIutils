#' Read data package report resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Report resource metadata
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
#'  packageId = "knb-lter-mcm.9129.3"
#' )
#' resourceMetadata
#' {xml_document}
#' <resourceMetadata>
#'  [1] <dateCreated>2021-04-27 17:50:46.084</dateCreated>
#'  [2] <doi>doi:10.6073/pasta/26cc82b742eb99a667fae2c367032724</doi>
#'  [3] <entityId>null</entityId>
#'  [4] <entityName>null</entityName>
#'  [5] <fileName>null</fileName>
#'  [6] <identifier>9129</identifier>
#'  [7] <packageId>knb-lter-mcm.9129.3</packageId>
#'  [8] <principalOwner>uid=MCM,o=EDI,dc=edirepository,dc=org</principal ...
#'  [9] <resourceId>https://pasta.lternet.edu/package/eml/knb-lter-mcm/9 ...
#' [10] <resourceType>dataPackage</resourceType>
#' [11] <revision>3</revision>
#' [12] <scope>knb-lter-mcm</scope>
#' }
read_data_package_report_resource_metadata <- function(packageId,
                                                       env = "production") {
  url <- paste0(
    base_url(env), "/package/rmd/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
