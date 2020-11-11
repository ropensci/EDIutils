#' Replace missing value codes with a new value
#' 
#' @description 
#'     Missing value codes vary across data packages and some computational 
#'     environments have preferences (e.g. R uses NA). This function transform 
#'     these codes to make downstream use simpler.
#'
#' @param x
#'     (data frame) Data with missing value codes to convert to NA.
#' @param eml
#'     (xml_document xml_node) EML metadata listing missing value codes for 
#'     \code{x}. Use \code{EDIutils::api_read_metadata()} or 
#'     \code{xml2::read_xml()} to read the EML file.
#' @param with
#'     (character or NA) New missing value code. This value will replace those 
#'     listed in \code{x} as specified by \code{eml}. Default is NA.
#' @param file
#'     (character) Name of the file, which \code{x} was created from (e.g. 
#'     "Resin_Deposition.csv". Use this argument if a column in \code{x} 
#'     has more than one match in \code{x} (see details).
#' @param coerce
#'     (logical) Columns of \code{x} defined as numeric in \code{eml} will be
#'     coerced to numeric after missing value code replacement. Default is 
#'     TRUE.
#'
#' @return 
#'     (data frame) \code{x} with missing value codes replaced with 
#'     \code{with}.
#'     
#' @details
#'     For each column in \code{x} a matching attribute is searched for in 
#'     \code{eml}. If one is found, then the missing value code listed in 
#'     \code{eml} is replaced in the data with \code{with}. If more than one
#'     attribute is found then an error is returned prompting the use of the 
#'     \code{file} argument. \code{file} maps to 
#'     /eml/dataset/dataTable/physical/objectName in \code{eml} and creates an 
#'     unambiguous column name/attribute match.
#'     
#'     Columns in \code{x} that are defined in \code{eml} as numeric, but 
#'     are read in as character due to the missing value code, are converted
#'     to numeric.
#'     
#' @export
#'
replace_missing_value_codes <- function(
  x = NULL, eml = NULL, with = NA, file = NULL, coerce = TRUE) {
  
  message("Replacing missing value codes with ", with)
  
  # Validate arguments
  if (is.null(x) | is.null(eml)) {
    stop("Both arguments 'x' and 'eml' are required.", call. = FALSE)
  }
  if (!is.data.frame(x)) {
    stop("'x' should be a data.frame.", call. = FALSE)
  }
  if (!any(class(eml) %in% c("xml_document", "xml_node"))) {
    stop("'eml' should be an 'xml_document' 'xml_node'.", call. = FALSE)
  }
  if (!is.null(file)) {
    file_in_eml <- file %in% xml2::xml_text(
      xml2::xml_find_all(eml, ".//dataTable/physical/objectName"))
    if (!file_in_eml) {
      stop("'file' cannot be found in 'eml'.", call. = FALSE)
    }
  }
  
  # List attributes and corresponding missing value codes of "x"
  attributes <- xml2::xml_find_all(eml, ".//attributeList/attribute")
  attributeNames <- xml2::xml_text(
    xml2::xml_find_all(eml, ".//attributeList/attribute/attributeName"))

  # Replace missing value codes
  for (col in colnames(x)){
    missing_value_code <- xml2::xml_text(
      xml2::xml_find_all(
        attributes[attributeNames %in% col], ".//missingValueCode/code"))
    unit <- xml2::xml_text(
      xml2::xml_find_all(
        attributes[attributeNames %in% col], ".//unit"))
    if (length(missing_value_code) == 1) {
      x[[col]][x[[col]] %in% missing_value_code] <- with
      # If has unit then coerce to numeric
      if (length(unit) == 1) {
        x[[col]] <- suppressWarnings(as.numeric(x[[col]]))
      }
    } else if (length(missing_value_code) > 1) {
      stop("More than one missing value code found for '", col, 
           "'. Use 'file' to disabmiguate.", call. = FALSE)
    }
  }

  # Return
  x
  
}
