#' Read data entity access control list
#'
#' @param package.id (character) Package identifier composed of scope, identifier, and revision (e.g. 'edi.101.1').
#' @param entityId (character) Data entity identifier (e.g. 5c224a0e74547b14006272064dc869b1)
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development"
#'
#' @return (xml_document) The access control list for the data entity. Please note: only a very limited set of users are authorized to use this service method.
#' 
#' @details GET : https://pasta.lternet.edu/package/data/acl/eml/{scope}/{identifier}/{revision}/{entityId}
#' 
#' @export
#' 
#' @examples 
#'
read_data_entity_acl <- function(package.id, 
                                 entityId, 
                                 environment = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  url <- paste0(url_env(environment), ".lternet.edu/package/data/acl/eml/", 
                paste(parse_packageId(package.id), collapse = "/"), '/', entityId)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  res <- read.csv(text = c("entityId", parsed), as.is = TRUE)
  return(res)
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/data/acl/eml/',
      parse_packageId(package.id),
      '/',
      entityId)
  )
  
  r <- httr::content(
    r,
    as = 'text',
    encoding = 'UTF-8'
  )
  
  output <- as.character(
    read.csv(
      text = c(
        'identifier',
        r
      ),
      as.is = T
    )$identifier
  )
  
  output
  
}