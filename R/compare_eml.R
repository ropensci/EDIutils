#' Did EML change between versions?
#' 
#' @description If changes to descriptions and other human defined elements, then semantic meaning may have changed too and thus may have ramifications for downstream processes.
#'
#' @param newest (xml_document, xml_node) EML of the newest version of a data package, where inputs are returned from \code{api_read_metadata()}.
#' @param previous (xml_document, xml_node) EML of the previous version of a data package, where inputs are returned from \code{api_read_metadata()}.
#'
#' @return (list) A list of differences.
#' @export
#'
#' @examples
#' 
compare_eml <- function(newest, 
                        previous) {
  
  # Abstract "previous" == "newest"
  # Coverage "previous" == "newest" (geographic, taxonomic, temporal)
  # Methods "previous" == "newest"
  # keywordSet "previous" == "newest"
  # dataTable "previous" == "newest"
  # otherEntity "previous" == "newest"
  
  return(differences)
  
}