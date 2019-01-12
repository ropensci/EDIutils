#' Get attribute metadata
#'
#' @description
#'     Retrieve metadata for an attribute
#'
#' @usage get_eml_attribute(attr.name, package.id)
#'
#' @param attr.name
#'     (character) Name of an attribute found in an EML metadata record
#' @param package.id
#'     (character) ID of data package found in the Environmental Data
#'     Initiative repository (e.g. knb-lter-cap.627.3), containing the
#'     attribute defined by "attr.name".
#'
#' @return
#'     A named vector of metadata elements for the specified "attr.name". NA is
#'     returned when the metadata element doesn't exist.
#'
#' @export
#'

get_eml_attribute <- function(attr.name, package.id){

  message(
    paste0(
      'Searching ',
      package.id,
      ' for "',
      attr.name,
      '"'
    )
  )

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
                 "']//standardUnit")],
        XML::xmlValue
      ), silent = TRUE)
    )
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
