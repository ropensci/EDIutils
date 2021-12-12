#' Delete data package
#'
#' @param scope (character) Scope of data package
#' @param identifier (numeric) Identifier of data package
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#' 
#' @return (logical) TRUE if deleted
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' 
#' }
#'
delete_data_package <- function(scope, identifier, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/eml/", scope, "/", 
                identifier)
  cookie <- bake_cookie()
  resp <- httr::DELETE(url, 
                       set_user_agent(), 
                       cookie, 
                       handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  if (resp$status_code == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
