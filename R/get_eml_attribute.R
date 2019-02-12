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
  
  scope <- unlist(stringr::str_split(package.id, '\\.'))[1]
  identifier <- unlist(stringr::str_split(package.id, '\\.'))[2]
  revision <- unlist(stringr::str_split(package.id, '\\.'))[3]
  
  metadata <- XML::xmlParse(paste("http://pasta.lternet.edu/package/metadata/eml",
                             "/",
                             scope,
                             "/",
                             identifier,
                             "/",
                             revision,
                             sep = ""))
  entity_names <- unlist(
    XML::xmlApply(metadata["//dataset/dataTable/entityName"],
             XML::xmlValue)
  )

  # Get the attributes definition and unit
  
  for (i in 1:length(entity_names)){
    definition <- unlist(
      try(XML::xmlApply(
        metadata[
          paste0("//dataTable[./entityName = '",
                 entity_names[i],
                 "']//attribute[./attributeName = '",
                 attr.name,
                 "']//attributeDefinition")],
        XML::xmlValue
      ), silent = TRUE)
    )
    
    unit <- unlist(
      try(XML::xmlApply(
        metadata[
          paste0("//dataTable[./entityName = '",
                 entity_names[i],
                 "']//attribute[./attributeName = '",
                 attr.name,
                 "']//standardUnit")
        ],
        XML::xmlValue
      ), silent = TRUE)
    )
    if (is.null(unit)){
      unit <- unlist(
        try(XML::xmlApply(
          metadata[
            paste0("//dataTable[./entityName = '",
                   entity_names[i],
                   "']//attribute[./attributeName = '",
                   attr.name,
                   "']//customUnit")
            ],
          XML::xmlValue
        ), silent = TRUE)
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
