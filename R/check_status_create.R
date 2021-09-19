#' Check data package creation status
#'
#' @param transaction (character) Transaction identifier
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (logical) TRUE if evaluation has completed, FALSE if in progress, and error if an error was encountered while processing the request
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' transaction <- create_data_package(path)
#' packageId <- "edi.468.1"
#' check_status_create(transaction, packageId)
#' }
#'
check_status_create <- function(transaction, packageId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  read_data_package_error(transaction, tier)
  url = paste0(url_env(tier), ".lternet.edu/package/report/eml/",
               paste(parse_packageId(packageId), collapse = "/"))
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  if (resp$status == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}