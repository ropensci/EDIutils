#' Did the EML change between data package versions?
#' 
#' @description If changes to descriptions and other human defined elements, then semantic meaning may have changed too and thus have ramifications for downstream processes.
#'
#' @param newest (xml_document, xml_node) EML of the newest version of a data package, where inputs are returned from \code{api_read_metadata()}.
#' @param previous (xml_document, xml_node) EML of the previous version of a data package, where inputs are returned from \code{api_read_metadata()}.
#'
#' @return (character) A vector of check results
#' 
#' @details The current set of checks are rather simple. They collapse nodes into character strings and report whether the node has changed.
#' 
#' @export
#'
#' @examples
#' 
compare_eml <- function(newest, 
                        previous) {
  
  results <- list()
  
  # Abstract

  r <- compare_node_as_string(
    newest, previous, ".//dataset/abstract")
  results <- c(results, r)

  # Geographic coverage

  r <- compare_node_as_string(
    newest, previous, ".//dataset/coverage/geographicCoverage")
  results <- c(results, r)

  # Temporal coverage

  r <- compare_node_as_string(
    newest, previous, ".//dataset/coverage/temporalCoverage")
  results <- c(results, r)

  # Taxonomic coverage

  r <- compare_node_as_string(
    newest, previous, ".//dataset/coverage/taxonomicCoverage")
  results <- c(results, r)

  # Methods

  r <- compare_node_as_string(
    newest, previous, ".//dataset/methods")
  results <- c(results, r)

  # Keywords

  r <- compare_node_as_string(
    newest, previous, ".//dataset/keywordSet")
  results <- c(results, r)
  
  # Data table physical (doesn't check distribution)
  
  r <- compare_node_as_string(
    newest, previous, ".//dataTable/physical")
  results <- c(results, r)
  
  # Data table attributes
  
  r <- compare_node_as_string(
    newest, previous, ".//dataTable/attributeList")
  results <- c(results, r)
  
  # TODO: Compare dataTable in more detail
  # Object name
  # Checksum
  # Column names
  # Number of columns
  # Number of rows
  # Column classes
  # Field delimiter
  # Number of header lines
  # datetime format string
  
  # Other entity physical (doesn't check distribution)
  
  r <- compare_node_as_string(
    newest, previous, ".//otherEntity/physical")
  results <- c(results, r)
  
  return(unlist(results))
  
}








#' Collapse EML node and compare as string
#'
#' @param newest (xml_document, xml_node) EML of the newest version of a data package, where inputs are returned from \code{api_read_metadata()}.
#' @param previous (xml_document, xml_node) EML of the previous version of a data package, where inputs are returned from \code{api_read_metadata()}.
#' @param xpath (character) xpath to node of interest
#'
#' @return
#' 
compare_node_as_string <- function(newest, previous, xpath) {
  
  # Don't compare distribution since this always changes. Operate on a copy of 
  # the newest and previous EML otherwise the url node will be dropped from the
  # global environment from which this function is called and thus will affect
  # downstream processes
  
  eml_newest <- newest
  eml_previous <- previous
  
  if (xpath %in% c(".//dataTable/physical", ".//otherEntity/physical")) {
    
    distribution <- xml2::xml_find_all(
      eml_newest, paste0(".//", xpath, "/distribution"))
    xml2::xml_remove(distribution)
    
    distribution <- xml2::xml_find_all(
      eml_previous, paste0(".//", xpath, "/distribution"))
    xml2::xml_remove(distribution)
    
  }
  
  # Collapse to string
  
  eml_newest <- xml2::xml_text(
    xml2::xml_find_all(eml_newest, xpath))
  
  eml_previous <- xml2::xml_text(
    xml2::xml_find_all(eml_previous, xpath))
  
  # Compare strings and return
  
  if (all(eml_newest == eml_previous)) {
    paste0("'", xpath, "'", " is the same")
  } else if (any(eml_newest == eml_previous)) {
    paste0("'", xpath, "'", " is different at node ", 
           which(!(eml_newest == eml_previous)))
  } else {
    paste0("'", xpath, "'", " is different")
  }
  
}




