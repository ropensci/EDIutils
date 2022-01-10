#' Read data entity metadata
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_nodeset) The metadata of \code{entityId} in \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' # Read entity names and IDs
#' packageId <- "knb-lter-cap.691.2"
#' entities <- read_data_entity_names(packageId)
#' entities
#'
#' # Read metadata of the first entity
#' meta <- read_metadata_entity(packageId, entityId = entities$entityId[1])
#' meta
read_metadata_entity <- function(packageId, entityId, env = "production") {
  eml <- read_metadata(packageId, env)
  nodeset <- xml2::xml_find_all(eml, ".//physical//distribution/online/url")
  urls <- xml2::xml_text(nodeset)
  i <- grepl(entityId, urls)
  physical <- xml2::xml_find_all(eml, ".//physical")[i]
  res <- xml2::xml_parent(physical)
  return(res)
}
