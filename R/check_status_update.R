#' Check data package update status
#'
#' @param transaction (character) Transaction identifier
#' @param packageId (character) Data package identifier of the form "scope.identifier.revision"
#' @param wait (logical) Wait for evaluation to complete? See details below.
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (logical) TRUE if the update has completed, FALSE if in progress, and error if an error was encountered while processing the request
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @details If \code{wait = TRUE}, then the function will enter a "while" loop checking every 2 seconds for the completed evaluation report. If \code{wait = FALSE}, then the function will only check once and return the result.
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' path <- "/Users/me/Documents/edi.468.2.xml"
#' transaction <- update_data_package(path)
#' packageId <- "edi.468.2"
#' check_status_update(transaction, packageId)
#' }
#'
check_status_update <- function(transaction, packageId, wait = TRUE, tier = "production") {
  validate_arguments(x = as.list(environment()))
  if (wait) {
    while (TRUE) {
      Sys.sleep(2)
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
  } else {
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
}