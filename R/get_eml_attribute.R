#' Get metadata for an attribute
#'
#' @description
#'     Get attribute metadata
#'
#' @usage get_eml_attribute(attr.name, package.id)
#'
#' @param attr.name
#'     (character) Attribute name
#' @param package.id
#'     (character) Data package identifier (e.g. knb-lter-cap.627.3) in the 
#'     EDI Data Repository.
#'
#' @return 
#'     (list) A named vector with these attribute elements:
#'     \itemize{
#'         \item{name} <attributeName>
#'         \item{definition} <attributeDefinition> 
#'         \item{unit} <standardUnit> or <customUnit>
#'     }
#'
#' @export
#'

get_eml_attribute <- function(attr.name, package.id){

  # Send message
  
  if (!is.na(attr.name)){
    message(paste0('Searching ', package.id, ' for "', attr.name, '"'))
  }

  # Load EML
  
  metadata <- api_read_metadata(package.id)

  # Get definition
    
  definition <- try(
    xml2::xml_text(
      xml2::xml_find_all(
        x = metadata, 
        xpath = paste0(
          "//definition[ancestor::attribute[child::attributeName[text() = '",
          attr.name,
          "']]]"
        )
      )
    ),
    silent = TRUE
  )
  
  # Get standard unit
  
  unit <- try(
    xml2::xml_text(
      xml2::xml_find_all(
        x = metadata, 
        xpath = paste0(
          "//standardUnit[ancestor::attribute[child::attributeName[text()  = '",
          attr.name,
          "']]]"
        )
      )
    ),
    silent = TRUE
  )
  
  # Get custom unit
  
  if (identical(unit, character(0))){
    unit <- try(
      xml2::xml_text(
        xml2::xml_find_all(
          x = metadata, 
          xpath = paste0(
            "//customUnit[ancestor::attribute[child::attributeName[text()  = '",
            attr.name,
            "']]]"
          )
        )
      ),
      silent = TRUE
    )
  }
  
  # Parse results
  
  if (class(definition) != 'character'){
    definition <- NA_character_
  }
  
  if (class(unit) != 'character'){
    unit <- NA_character_
  }
  
  if (!is.na(definition) | !is.na(unit)){
    break
  }

  # Return results
  
  list(
    name = attr.name,
    definition = definition,
    unit = unit
  )

}
