#' Get metadata for an attribute
#'
#' @description
#'     Get metadata for an attribute.
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

  if (!is.na(attr.name)){
    message(paste0('Searching ', package.id, ' for "', attr.name, '"'))
  }

  # Load EML and data entity names
  
  metadata <- api_read_metadata(package.id = package.id)
  
  entity_names <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/physical/objectName"
    )
  )

  # Get the attributes definition and unit
  
  for (i in 1:length(entity_names)){
    
    definition <- try(
      xml2::xml_text(
        xml2::xml_find_all(
          x = metadata, 
          xpath = paste0(
            "//dataTable[./entityName = '",
            entity_names[i],
            "']//attribute[./attributeName = '",
            attr.name,
            "']//attributeDefinition"
          )
        )
      ),
      silent = TRUE
    )
    
    unit <- try(
      xml2::xml_text(
        xml2::xml_find_all(
          x = metadata, 
          xpath = paste0(
            "//dataTable[./entityName = '",
            entity_names[i],
            "']//attribute[./attributeName = '",
            attr.name,
            "']//standardUnit"
          )
        )
      ),
      silent = TRUE
    )
    
    if (identical(unit, character(0))){
      unit <- try(
        xml2::xml_text(
          xml2::xml_find_all(
            x = metadata, 
            xpath = paste0(
              "//dataTable[./entityName = '",
              entity_names[i],
              "']//attribute[./attributeName = '",
              attr.name,
              "']//customUnit"
            )
          )
        ),
        silent = TRUE
      )
    }
    
    if (class(definition) != 'character'){
      definition <- NA_character_
    }
    if (class(unit) != 'character'){
      unit <- NA_character_
    }
    if (!is.na(definition) | !is.na(unit)){
      break
    }
  }

  list(
    name = attr.name,
    definition = definition,
    unit = unit
  )

}
