#' List user data packages
#'
#' @description List all data packages (including their revision values) uploaded to the repository by a particular user, specified by a distinguished name. Data packages that were uploaded by the specified user but have since been deleted are excluded from the list.
#'
#' @usage list_user_data_packages(dn, environment = 'production')
#'
#' @param dn
#'     (character) Distinguished name (e.g. 'uid=csmith,o=LTER,dc=ecoinformatics,dc=org')
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#'
#' @return
#'     (character) Data packages uploaded by a distinguished name.
#'
#' @details GET : https://pasta.lternet.edu/package/user/{dn}
#'
#' @export
#' 
#' @examples 
#' # Using curl to list all (undeleted) data packages uploaded by user ucarroll with distinguished name uid=ucarroll,o=LTER,dc=ecoinformatics,dc=org:
#'
list_user_data_packages <- function(dn, environment = 'production'){
  
  message(paste('Listing data packages uploaded by', dn))
  
  validate_arguments(x = as.list(environment()))
  
  r <- httr::GET(
    url = paste0(
      url_env(environment),
      '.lternet.edu/package/user/',
      dn
    )
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
