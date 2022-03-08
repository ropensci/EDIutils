#' Read data entity resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) The resource metadata of 
#' \code{entityId} in \code{packageId}
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
#' }
read_data_entity_resource_metadata <- function(packageId, 
                                               entityId,
                                               as = "data.frame",
                                               env = "production") {
  url <- paste0(
    base_url(env), "/package/data/rmd/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
