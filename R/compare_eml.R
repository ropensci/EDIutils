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
  
  # Abstract ------------------------------------------------------------------

  r <- compare_node_as_string(
    newest, previous, ".//dataset/abstract")
  results <- c(results, r)

  # Geographic coverage -------------------------------------------------------

  r <- compare_node_as_string(
    newest, previous, ".//dataset/coverage/geographicCoverage")
  results <- c(results, r)

  # Temporal coverage ---------------------------------------------------------

  r <- compare_node_as_string(
    newest, previous, ".//dataset/coverage/temporalCoverage")
  results <- c(results, r)

  # Taxonomic coverage --------------------------------------------------------

  r <- compare_node_as_string(
    newest, previous, ".//dataset/coverage/taxonomicCoverage")
  results <- c(results, r)

  # Methods -------------------------------------------------------------------

  r <- compare_node_as_string(
    newest, previous, ".//dataset/methods")
  results <- c(results, r)

  # Keywords ------------------------------------------------------------------

  r <- compare_node_as_string(
    newest, previous, ".//dataset/keywordSet")
  results <- c(results, r)
  
  # Data table physical -------------------------------------------------------
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//dataTable/physical/objectName")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//dataTable/physical/size")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//dataTable/physical/authentication")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//dataTable/physical/dataFormat/textFormat/numHeaderLines")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//dataTable/physical/dataFormat/textFormat/recordDelimiter")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//dataTable/physical/dataFormat/textFormat/attributeOrientation")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//dataTable/physical/dataFormat/textFormat/simpleDelimited/fieldDelimiter")
  results <- c(results, r)
  
  # Data table attributes -----------------------------------------------------
  
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
  
  # Other entity physical -----------------------------------------------------
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//otherEntity/physical/objectName")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//otherEntity/physical/size")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//otherEntity/physical/authentication")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//otherEntity/physical/dataFormat/textFormat/numHeaderLines")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//otherEntity/physical/dataFormat/textFormat/recordDelimiter")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//otherEntity/physical/dataFormat/textFormat/attributeOrientation")
  results <- c(results, r)
  
  r <- compare_node_as_string(
    newest, 
    previous, 
    ".//otherEntity/physical/dataFormat/textFormat/simpleDelimited/fieldDelimiter")
  results <- c(results, r)
  
  # Return --------------------------------------------------------------------
  
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
  
  # Collapse to string
  
  newest <- xml2::xml_text(
    xml2::xml_find_all(newest, xpath))
  
  previous <- xml2::xml_text(
    xml2::xml_find_all(previous, xpath))
  
  # Compare strings and return
  
  if (all(newest == previous)) {
    paste0("'", xpath, "'", " is the same")
  } else if (any(newest == previous)) {
    paste0("'", xpath, "'", " is different at node ", 
           which(!(newest == previous)))
  } else {
    paste0("'", xpath, "'", " is different")
  }
  
}




