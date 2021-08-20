#' Get audit record
#'
#' @description Gets a single audit record based on the audit identifier value specified in the path.
#'
#' @param attr.name
#'     (character) Attribute name
#' @param package.id
#'     (character) Data package identifier (e.g. knb-lter-cap.627.3) in the 
#'     EDI Data Repository.
#' @param evironment (character) Repository environment in which the L0 and L1 exist. Some repositories have development, staging, and production environments which are distinct from one another. This argument allows execution for the \code{update_L1} workflow within the context of one of these environments. Default is "production".
#'
#' @return 
#'     (list) A named vector with these attribute elements:
#'     \itemize{
#'         \item{name} <attributeName>
#'         \item{definition} <attributeDefinition> 
#'         \item{unit} <standardUnit> or <customUnit>
#'     }
#' @details GET : https://pasta.lternet.edu/audit/report/{oid}
#' @export
#' @examples 
#'
get_audit_record <- function(attr.name, package.id, environment = "production"){

  # Send message
  
  if (!is.na(attr.name)){
    message(paste0('Searching ', package.id, ' for "', attr.name, '"'))
  }

  # Load EML
  
  metadata <- suppressMessages(read_metadata(package.id, environment = environment))

  # Get definition
    
  definition <- try(
    xml2::xml_text(
      xml2::xml_find_all(
        x = metadata, 
        xpath = paste0(
          "//attributeDefinition[ancestor::attribute[child::attributeName[text() = '",
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
  } else {
    definition <- definition[1]
  }
  
  if (class(unit) != 'character'){
    unit <- NA_character_
  } else {
    unit <- unit[1]
  }

  # Return results
  
  list(
    name = attr.name,
    definition = definition,
    unit = unit
  )

}
