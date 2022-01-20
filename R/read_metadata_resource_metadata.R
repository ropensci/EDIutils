#' Read metadata resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Resource metadata for the data package metadata
#' resource
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read resource metadata
#' resourceMetadata <- read_metadata_resource_metadata(
#'  packageId = "knb-lter-pal.309.1"
#' )
#' resourceMetadata
#' #> {xml_document}
#' #> <resourceMetadata>
#' #>  [1] <dateCreated>2021-04-14 13:52:16.027</dateCreated>
#' #>  [2] <entityId>null</entityId>
#' #>  [3] <entityName>null</entityName>
#' #>  [4] <fileName>Level-1-EML.xml</fileName>
#' #>  [5] <formatType>https://eml.ecoinformatics.org/eml-2.2.0             ...
#' #>  [6] <identifier>309</identifier>
#' #>  [7] <md5Checksum>e1cbd509d73797dd4b23f0d30c30548d</md5Checksum>
#' #>  [8] <packageId>knb-lter-pal.309.1</packageId>
#' #>  [9] <principalOwner>uid=PAL,o=EDI,dc=edirepository,dc=org</principal ...
#' #> [10] <resourceId>https://pasta.lternet.edu/package/metadata/eml/knb-l ...
#' #> [11] <resourceType>metadata</resourceType>
#' #> [12] <revision>1</revision>
#' #> [13] <scope>knb-lter-pal</scope>
#' #> [14] <sha1Checksum>b3cf11fa06b72514a3e7483fdf28dfeb70e2f1de</sha1Chec ...
#' }
read_metadata_resource_metadata <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/metadata/rmd/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
