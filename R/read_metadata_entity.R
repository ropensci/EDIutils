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
#' \dontrun{
#' 
#' # Read entity names and IDs
#' packageId <- "knb-lter-cap.691.2"
#' entities <- read_data_entity_names(packageId)
#' entities
#' #>                           entityId
#' #> 1 f6e4efd0b04aea3860724824ca05c5dd
#' #> 2 d2263480e75cc7888b41928602cda4c6
#' #> 3 d5cb83e4556408e48f636157e4dee49e
#' #>                                                 entityName
#' #> 1      691_arthropods_00742cd00ab0d3d02337e28d1c919654.csv
#' #> 2        691_captures_e5f57a98ae0b7941b10d4a600645495a.csv
#' #> 3 691_sampling_events_e8d76d7e76385e4ae84bcafb754d0093.csv
#' 
#' # Read metadata of the first entity
#' meta <- read_metadata_entity(packageId, entityId = entities$entityId[1])
#' meta
#' #> {xml_nodeset (1)}
#' #> [1] <dataTable id="691_arthropods_00742cd00ab0d3d02337e28d1c919654.cs ...
#' }
read_metadata_entity <- function(packageId, entityId, env = "production") {
  eml <- read_metadata(packageId, env)
  nodeset <- xml2::xml_find_all(eml, ".//physical//distribution/online/url")
  urls <- xml2::xml_text(nodeset)
  i <- grepl(entityId, urls)
  physical <- xml2::xml_find_all(eml, ".//physical")[i]
  res <- xml2::xml_parent(physical)
  return(res)
}
