#' Read data entity resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) The resource metadata of \code{entityId} in
#' \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List entities
#' entityIds <- list_data_entities(packageId = "knb-lter-cce.310.1")
#' head(entityIds)
#' #> [1] "4aaaff61e0d316130be0b445d3013877"
#' #> [2] "088775341e7fb65206af8c9e67d076e2"
#' #> [3] "6982dd80cba66470c49a2f3dc0f82459"
#' #> [4] "782fbaa20ea62987c838378e9eadcfa6"
#' #> [5] "ae8ecd148df1275b30358577d0fa6b4a"
#' #> [6] "a53b312efe0a176fdfc74ab7ccb0916b"
#' 
#' # Read resource metadata for first entity
#' resourceMetadata <- read_data_entity_resource_metadata(
#'  packageId = "knb-lter-cce.310.1",
#'  entityId = entityIds[1]
#' )
#' resourceMetadata
#' #> {xml_document}
#' #> <resourceMetadata>
#' #>  [1] <dataFormat>NetCDF (gzipped tar archive)</dataFormat>
#' #>  [2] <dateCreated>2021-08-13 11:23:40.81</dateCreated>
#' #>  [3] <entityId>4aaaff61e0d316130be0b445d3013877</entityId>
#' #>  [4] <entityName>water_age_CCE_1994.tar</entityName>
#' #>  [5] <fileName>water_age_CCE_1994.tar.gz</fileName>
#' #>  [6] <identifier>310</identifier>
#' #>  [7] <md5Checksum>8b22bf5c72c405aab93e44a6aa5b7d79</md5Checksum>
#' #>  [8] <packageId>knb-lter-cce.310.1</packageId>
#' #>  [9] <principalOwner>uid=EDI,o=EDI,dc=edirepository,dc=org</principal ...
#' #> [10] <resourceId>https://pasta.lternet.edu/package/data/eml/knb-lter- ...
#' #> [11] <resourceLocation>/pasta/data1</resourceLocation>
#' #> [12] <resourceSize>322263158</resourceSize>
#' #> [13] <resourceType>data</resourceType>
#' #> [14] <revision>1</revision>
#' #> [15] <scope>knb-lter-cce</scope>
#' #> [16] <sha1Checksum>bccdcfef105aa7b787db1fd940ad8ea2a5d04295</sha1Chec ...
#' }
read_data_entity_resource_metadata <- function(packageId, entityId,
                                               env = "production") {
  url <- paste0(
    base_url(env), "/package/data/rmd/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
