#' Read data tables of a data package
#' 
#' @description Read data tables of a data package from the EML metadata.
#' 
#' @param eml (xml_document, xml_node) EML metadata returned from \code{read_eml()}
#' 
#' @return (list) List of named data frames
#' 
#' @details This function uses \code{data.table::fread()} and uses default argument values if the EML based values return an error.
#' 
#' @export
#'
#' @examples
#' 
#' d <- read_tables(api_read_metadata("knb-lter-nwt.1.6"))
#' 
read_tables <- function(eml) {
  
  tbl_metadata <- xml2::xml_find_all(eml, ".//dataTable/physical")
  
  tbls <- lapply(
    tbl_metadata,
    function(x) {
      
      # Get physical attributes from eml
      
      object_name <- xml2::xml_text(
        xml2::xml_find_all(x, ".//objectName"))
      
      orientation <- xml2::xml_text(
        xml2::xml_find_all(x, ".//attributeOrientation"))
      
      header_lines <- xml2::xml_integer(
        xml2::xml_find_all(x, ".//numHeaderLines"))
      
      field_delimiter <- xml2::xml_text(
        xml2::xml_find_all(x, ".//fieldDelimiter"))
      
      url <- xml2::xml_text(
        xml2::xml_find_all(x, ".//url"))
      
      # Stop if orientation is not column
      # FIXME: Extend support to other orientations
      
      if (!("column" %in% orientation)) {
        stop("Only column oriented tables are supported at this time.", 
             call. = FALSE)
      }
      
      # Read table based on physical attributes. If error, then try default 
      # argument values.
      
      tbl <- tryCatch(
          data.table::fread(
            input = url,
            sep = field_delimiter,
            skip = header_lines - 1), 
          error = function(e) {
            data.table::fread(input = url)})
      
      tbl <- list(tbl)
      names(tbl) <- object_name
      return(tbl)
      
    })
  
  return(unlist(tbls, recursive = FALSE))
  
}