#' Get data entity physical metadata
#'
#' @param eml (xml_document) EML metadata
#' @param entityId (character) Data entity identifier
#'
#' @return (xml_node) The physical metadata of \code{entityId} as described in \code{eml}
#'
#' @export
#' 
#' @examples 
#' entityId <- "f6e4efd0b04aea3860724824ca05c5dd"
#' eml <- read_metadata("knb-lter-cap.691.2")
#' phys <- get_physical(eml, entityId)
#' phys
#'
get_physical <- function(eml, entityId) {
  nodeset <- xml2::xml_find_all(eml, ".//physical//distribution/online/url")
  urls <- xml2::xml_text(nodeset)
  i <- grepl(entityId, urls)
  res <- xml2::xml_find_all(eml, ".//physical")[i]
  return(res)
}


