#' Read data package resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Resource metadata of \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read resource metadata
#' resourceMetadata <- read_data_package_resource_metadata(
#'  packageId = "edi.613.1"
#' )
#' resourceMetadata
#' #> {xml_document}
#' #> <resourceMetadata>
#' #>  [1] <dateCreated>2021-06-08 18:02:43.361</dateCreated>
#' #>  [2] <doi>doi:10.6073/pasta/47d7cb6d374b6662cce98e42122169f8</doi>
#' #>  [3] <entityId>null</entityId>
#' #>  [4] <entityName>null</entityName>
#' #>  [5] <fileName>null</fileName>
#' #>  [6] <identifier>613</identifier>
#' #>  [7] <packageId>edi.613.1</packageId>
#' #>  [8] <principalOwner>uid=EDI,o=EDI,dc=edirepository,dc=org</principal ...
#' #>  [9] <resourceId>https://pasta.lternet.edu/package/eml/edi/613/1</res ...
#' #> [10] <resourceType>dataPackage</resourceType>
#' #> [11] <revision>1</revision>
#' #> [12] <scope>edi</scope>
#' }
read_data_package_resource_metadata <- function(packageId,
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
